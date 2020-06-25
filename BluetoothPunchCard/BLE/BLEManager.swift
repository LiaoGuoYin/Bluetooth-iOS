//
//  BLEManager.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/16.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

let BLE_Punchcard_Main_Service_CBUUID = CBUUID(string: "0xFFE1") // Main service
let BLE_Punchcard_Notify_Characterristic_CBUUID = CBUUID(string: "0xFFE2") // Notify characteristic
let BLE_Punchcard_Write_Characterristic_CBUUID = CBUUID(string: "0xFFE3") // Write characteristic

open class BLEManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate, ObservableObject {

    // Message Console
    @Published var message: String = "初始化成功.."

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
        startCentralManager()
    }

    /// 初始化中心设备（本机）
    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        NSLog("Central Manager State: \(self.centralManager.state)")

        message.addString("初始化本机蓝牙设置成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.centralManagerDidUpdateState(self.centralManager)
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
                    self.centralManager.stopScan()
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
                    self.peripheralManager.writeValue(Data(csvTxtDemo.utf8), for: characteristic, type: .withoutResponse)
                    //                    self.peripheralManager.writeValue("写测试", for: CBDescriptor(characteristic))
                    message.addString("写特征找到，订阅成功")
                }
            }
        }
    }

    /// 订阅读取外设数据
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - characteristic: characteristic description
    ///   - error: error description
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == BLE_Punchcard_Notify_Characterristic_CBUUID {
            message.addString("收到数据：")
            if let messageData = characteristic.value {

                if let dataStr = String(data: messageData, encoding: .utf8) {
                    message.addString(dataStr)

                    /*
                     HeartRate:77
                     Step:0
                     Distance:0.0
                     Temperature:26.6
                     */

                    if dataStr.hasPrefix("姓名,班级,学号,MAC") {
                        parseRecord(of: dataStr)
                    }

                    let dataArray = dataStr.split(separator: "\n")
                    for data in dataArray {
                        NSLog(String(data))
                        message.addString((String(data)))
                    }
                }
            }
        }
    }
}

extension String {
    mutating func addString(_ str: String) {
        self = str + "\n"
    }
}

struct Student {
    var name: String
    var classOf: String
    var number: String
    var mac: String
    var status: String?
}

var csvTxtDemo = """
姓名,班级,学号,MAC,status
欧珀,电信研181,471820336,4c1a3d493e6c,√
吴埃斯,电信研183,123456778,BCE143B46210,√
吴一帆,工商研183,123456789,7836CC44578C,
杨清雷,土木研183,234567890,3CA581792440,
张世晔,英语研183,345678901,D461DA37FC98,
霍泽生,数学研183,456789112,A4504689B81F,
吕英鑫,工管研183,123231132,9487E09F9B02,√
初殿宇,法学研183,234563457,A4933F817F83,
刘埃斯,工商研184,225039186,044BED769B5E,
方彦瑾,安全研183,345678922,9CE82B8128AC,
铁牛,电控研181,863487827,4404446AA450,
袁超,安全研183,683268688,482CA03CDEB7,√
唐玉莲,工管研183,671256411,F4BF8008D846,
周雪,财贸研183,67136728,047970E090B6,
潘佳欣,法学研183,315263533,A4933F818390,
皮克嗖,英语研185,527737383,B4F1DA9A361D,√
维沃,机械研182,352033185,488764443630,
十一,电信研188,342708190,B87BC5C6303B,√
"""

/// 反序列化转换获取到的 CSV 字符串信息为对象
/// - Parameter csvTxt: CSV 格式文本，逗号分隔
func parseRecord(of csvTxt: String) {
    let records = csvTxt.split(separator: "\n")
    var student = Student(name: "", classOf: "", number: "", mac: "")

    for index in (1..<records.count) {
        let record = records[index].split(separator: ",")
        student.name = String(record[0])
        student.classOf = String(record[1])
        student.number = String(record[2])
        student.mac = String(record[3])
        
        if record.count == 5 {
            student.status = String(record[4])
        } else {
            student.status = nil
        }
        print(student)
    }
}
