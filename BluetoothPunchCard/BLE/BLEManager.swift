//
//  BLEManager.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/16.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import CoreBluetooth

let BLE_Punchcard_Main_Service_CBUUID = CBUUID(string: "0xFFE1") // Main service
let BLE_Punchcard_Notify_Characterristic_CBUUID = CBUUID(string: "0xFFE2") // Notify characteristic
let BLE_Punchcard_Write_Characterristic_CBUUID = CBUUID(string: "0xFFE3") // Write characteristic

open class BLEManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate, ObservableObject {
    @Published var isScanning: Bool = false

    // Message Console
    @Published var message: String = "初始化成功，请点击图标开始扫描。"

    // BLEConnection 单例
    static let shared = BLEManager()

    // 设备扫描到的蓝牙，回写到 SwiftUI View
    @Published var scannedBLEDevices: [CBPeripheral] = []

    // 自动连接的蓝牙前缀
    var names = ["NBee", "LGY"]

    var centralManager: CBCentralManager! = nil
    var peripheralManager: CBPeripheral! = nil

    public override init() {
        super.init()
        //        startCentralManager()
    }

    /// 初始化中心设备（本机）
    func startCentralManager() {
        self.isScanning = true
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        NSLog("Central Manager State: \(self.centralManager.state)")

        message.addString("初始化本机蓝牙成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.centralManagerDidUpdateState(self.centralManager)
        }
    }

    /// 停止扫描设备
    func stopCentralManager() {
        self.isScanning = false
        self.centralManager.stopScan()
    }

    /// 切换扫描状态
    func switchCentralManager() {
        if(self.isScanning) {
            self.stopCentralManager()
            self.isScanning = false
        } else {
            self.startCentralManager()
            self.isScanning = true
        }
    }

    /// 检测本机蓝牙状态
    /// - Parameter central: 中心设备管理器
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message = ""
        switch (central.state) {
        case .poweredOff:
            message = "poweredOff"
        case .poweredOn:
            self.isScanning = true
            //            全开扫描
            self.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])

            //            扫描指定 Service
            //            NSLog("Central is scanning: \(BLE_Punchcard_Main_Service_CBUUID)");
            //                        self.centralManager.scanForPeripherals(withServices: [BLEConnection.bleServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        case .resetting:
            message = "resetting"
        case .unknown:
            message = "unknown"
        case .unsupported:
            message = "unsupported"
        case .unauthorized:
            message = "unauthorized"
            //            switch central.state {
            //            case .poweredOn:
            //                message = "OK"
            //            case .denied:
            //                message = "denied"
            //            case .restricted:
            //                message = "restricted"
            //            case .notDetermined:
            //                message = "Not Determined"
            //            @unknown default:
            //                message = "unknown"
            //            }
            @unknown default:
            message = "unknown(default)"
        }
        NSLog(message as String)
    }

    /// 处理蓝牙扫描结果
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    ///   - advertisementData: advertisementData description
    ///   - RSSI: RSSI description
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        NSLog("New discovery! Peripheral Name: \(String(describing: peripheral.name))  RSSI: \(String(RSSI.doubleValue))")
        self.scannedBLEDevices.append(peripheral)
        //                self.scannedBLEDevices[peripheral.name ?? ""] = peripheral
        //                self.scannedBLEDevices[peripheral.self] = abs(Double(truncating: RSSI))
        self.peripheralManager = peripheral
        self.peripheralManager.delegate = self

        //            自动链接指定前缀的蓝牙设备
        if let peripheralName = peripheral.name {
            for name in names {
                if peripheralName.hasPrefix(name) {
                    self.stopCentralManager()
                    self.centralManager.connect(peripheral, options: nil)
                    NSLog("Finding target：\(peripheralName) \n Stop scanning now, connecting to it..")
                    break
                }
            }
        }

        // TODO 其他连接方式

        // TODO 可能丢失。另一个线程

    }

    /// 连接成功的处理
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("Connected to \(String(describing: peripheral.name)) Successfully!")
        peripheral.discoverServices(nil)
    }

    /// 处理发现的 Services
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - error: error description
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

        //        找到指定的 Service
        if let services = peripheral.services {
            for service in services {
                if service.uuid == BLE_Punchcard_Main_Service_CBUUID {
                    NSLog("Found Main Service")
                    message.addString("找到 Service")
                    peripheral.discoverCharacteristics(nil, for: service)
                    break
                }
            }
        }

        // TODO 自选 Service Mode
    }

    /// 处理已经发现的外设 Characteristics，读 / 写
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - service: service description
    ///   - error: error description
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //        self.peripheralManager = peripheral
        //        self.peripheralManager.delegate = self

        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == BLE_Punchcard_Notify_Characterristic_CBUUID {
                    NSLog("通知特征找到，订阅成功")
                    self.peripheralManager.setNotifyValue(true, for: characteristic)
                    message.addString("通知特征找到，订阅成功")
                } else if characteristic.uuid == BLE_Punchcard_Write_Characterristic_CBUUID {
                    NSLog("写特征找到，订阅成功")
                    //                    self.peripheralManager.setNotifyValue(true, for: characteristic)
                    //                    self.peripheralManager.writeValue(Data(csvTxtDemo.utf8), for: characteristic, type: .withoutResponse)
                    //                    self.peripheralManager.writeValue("写测试", for: CBDescriptor(characteristic))
                    message.addString("写特征找到，订阅成功")
                }
            }
        }
    }

    /// Notify / Write 外设数据
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - characteristic: characteristic description
    ///   - error: error description
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == BLE_Punchcard_Notify_Characterristic_CBUUID {
            message.addString("订阅成功，将会收到数据！")
            if let messageData = characteristic.value {

                if let dataStr = String(data: messageData, encoding: .utf8) {
                    message.addString(dataStr)

                    if dataStr.hasPrefix("姓名,班级,学号,MAC") {
                        message.addString("收到签到回馈：")

                        let dataArray = dataStr.split(separator: "\n")
                        for data in dataArray {
                            NSLog(String(data))
                            message.addString((String(data)))
                        }
                    }
                }
            }
        } else if characteristic.uuid == BLE_Punchcard_Write_Characterristic_CBUUID {
            message.addString("连接通道建立成功，可以开始写入数据！(测试模式自动发送写入请求)")
            self.peripheral.writeValue(Data("CSVDemo".utf8), for: characteristic, type: .withoutResponse)
            self.message.addString("写入请求发送成功！")
        }
    }
}

extension String {
    mutating func addString(_ str: String) {
        self = str + "\n"
    }
}

//extension BLEManager {
//    func writeToDevices(of characteristic: CBCharacteristic) {
//    }
//}
