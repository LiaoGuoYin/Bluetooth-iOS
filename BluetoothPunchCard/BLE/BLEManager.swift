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

    static let shared = BLEManager()
    
    @Published var message: String = "初始化成功，请点击图标开始扫描。\n"
    
    @Published var scannedBLEDevices: [CBPeripheral] = []
    
    @Published var isScanning: Bool = false
    
    var isConnected: Bool = false

    // 自动连接的蓝牙前缀
    var names = ["NBee", "LGY"]
    
    var centralManager: CBCentralManager! = nil
    
    var peripheralManager: CBPeripheral! = nil

    var connectedDeviceName: String {
        peripheralManager.name ?? "Disconnected"
    }

    //    MARK: - 委托类字典
    private var delegateDict = Dictionary<Int, BluetoothHelperDelegate>()

    func registerDelegate(delegate: BluetoothHelperDelegate) {
        delegateDict[delegate.bluetoothHelperIndex()] = delegate
    }

    func unregisterDelegate(delegate: BluetoothHelperDelegate) {
        delegateDict.removeValue(forKey: delegate.bluetoothHelperIndex())
    }

    public override init() {
        super.init()
        self.isScanning = false
        self.isConnected = false
        //        startCentralManager()
    }

    /// 初始化
    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.centralManagerDidUpdateState(self.centralManager)
        }
    }

    /// 检测蓝牙状态
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message = ""
        switch (central.state) {
        case .poweredOff:
            message = "蓝牙尚未未开启"
        case .poweredOn:
            // 全开扫描
            self.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
            self.isScanning = true
            message.addString("初始化成功，开始扫描")
            NSLog("初始化成功，开始扫描")

            // TODO 扫描指定 Service
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
            @unknown default:
            message = "未知状态，请检查蓝牙设置"
        }
        NSLog(message as String)
    }

    /// 发现设备，连接设备
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        NSLog("New discovery! Peripheral Name: \(String(describing: peripheral.name))  RSSI: \(String(RSSI.doubleValue))")
        self.scannedBLEDevices.append(peripheral)
        self.peripheralManager = peripheral
        self.peripheralManager.delegate = self
        // 自动链接指定前缀的蓝牙设备
        if let peripheralName = peripheral.name {
            for name in names {
                if peripheralName.hasPrefix(name) {
                    self.centralManager.connect(peripheral, options: nil)
                    NSLog("Finding target：\(peripheralName) \n Stop scanning now, connecting to it..")
                    break
                }
            }
        }
        // TODO 其他连接方式
        // TODO 可能丢失。另一个线程
    }

    /// 连接成功，扫描 Services
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        message.addString("连接成功：\(self.connectedDeviceName)")
        NSLog("连接成功：\(self.connectedDeviceName)")
        self.isConnected = true
        self.centralManager.stopScan()
        peripheral.discoverServices(nil)
    }

    /// 发现 Services，扫描下属的 Characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // 找到指定 Service
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

    /// 发现 Characteristics ，订阅读/写
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == BLE_Punchcard_Notify_Characterristic_CBUUID {
                    self.peripheralManager.setNotifyValue(true, for: characteristic)
                    message.addString("通知特征找到，订阅成功")
                    NSLog("通知特征找到，订阅成功")
                } else if characteristic.uuid == BLE_Punchcard_Write_Characterristic_CBUUID {
                    //                    self.peripheralManager.setNotifyValue(true, for: characteristic)
                    //                    self.peripheralManager.writeValue(Data(csvTxtDemo.utf8), for: characteristic, type: .withoutResponse)
                    //                    self.peripheralManager.writeValue("写测试", for: CBDescriptor(characteristic))
                    message.addString("写特征找到，订阅成功")
                    NSLog("写特征找到，订阅成功")
                }
            }
        }
    }

    /// 读/写外设数据
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
            peripheral.writeValue(Data("CSVDemo".utf8), for: characteristic, type: .withoutResponse)
            message.addString("写入请求发送成功！")
        }
    }

    /// 断开连接
    func disConnect() {
        if(self.peripheralManager != nil) {
            self.centralManager.cancelPeripheralConnection(peripheralManager)
            message.addString("断开链接！")
            NSLog("断开链接！")
        }
    }

    /// 断开设备
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        message.addString("断开设备：\(self.connectedDeviceName)")
        NSLog("断开设备：\(self.connectedDeviceName)")
        self.isConnected = false
    }
    
    /// 打开/关闭扫描
    func switchCentralManager() {
        if(self.isScanning) {
            self.centralManager.stopScan()
            self.isScanning = false
        } else {
            self.disConnect()
            self.startCentralManager()
            self.isScanning = true
        }
    }

}

extension String {
    mutating func addString(_ str: String) {
        self = self + str + "\n"
    }
}

protocol BluetoothHelperDelegate {
    func bluetoothScan(peripheral: CBPeripheral)
    func bluetoothHelperIndex() -> Int
    func bluetoothConnect(name: String)
    func bluetoothDisconnect(name: String)
}

extension BluetoothHelperDelegate {
    func bluetoothConnect(name: String) { }
    func bluetoothDisconnect(name: String) { }
}

//extension BLEManager {
//    func writeToDevices(of characteristic: CBCharacteristic) {
//    }
//}
