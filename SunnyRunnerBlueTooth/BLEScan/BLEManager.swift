//
//  BLEManager.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth


let BLE_Punchcard_Main_Service_CBUUID = CBUUID(string: "0xFFE1") // Main

let BLE_Punchcard_Notify_Characterristic_CBUUID = CBUUID(string: "0xFFE2") // Notify
let BLE_Punchcard_Write_Characterristic_CBUUID = CBUUID(string: "0xFFE3") // Write

open class BLEManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate, ObservableObject {
    
    // Message Console
    @Published var message: String = "Scannning.."
    
    // BLEConnection 单例
    static let shared = BLEManager()
    
    // 设备扫描到的蓝牙，回写到 SwiftUI View
    @Published var scannedBLEDevices = Dictionary<String, CBPeripheral>()
    
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
        print("Central Manager State: \(self.centralManager.state)")
        
        message.addString("初始化 Central Device: \(self.centralManager.state)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.centralManagerDidUpdateState(self.centralManager)
        }
    }
    
    /// 检测本机蓝牙状态
    /// - Parameter central: 蓝牙状态管理实例
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message = ""
        switch (central.state) {
        case .poweredOff:
            message = "poweredOff"
        case .poweredOn:
            print("Central is scanning for: ", BLE_Punchcard_Main_Service_CBUUID);
            //            self.centralManager.scanForPeripherals(withServices: [BLEConnection.bleServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            message = "resetting"
        case .unknown:
            message = "unknown yes"
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
            message = "unknown"
        }
        print(message as String)
    }
    
    /// 处理扫描结果
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    ///   - advertisementData: advertisementData description
    ///   - RSSI: RSSI description
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        print("New discovery! Peripheral Name: \(String(describing: peripheral.name))  RSSI: \(String(RSSI.doubleValue))")
//        message.addString("New discovery! Peripheral Name: \(String(describing: peripheral.name))  RSSI: \(String(RSSI.doubleValue))")
        
        //        self.scannedBLEDevices.append(peripheral)
        //        self.scannedBLEDevices[peripheral.name ?? ""] = peripheral
        //        self.scannedBLEDevices[peripheral.self] = abs(Double(truncating: RSSI))
        
        self.peripheralManager = peripheral
        self.peripheralManager.delegate = self
        
        if let peripheralName = peripheral.name {
            for name in names {
                if peripheralName.hasPrefix(name) {
                    // Connect!
                    self.centralManager.stopScan()
                    self.centralManager.connect(peripheral, options: nil)
                    print("扫描到：\(peripheralName) 停止扫描，建立连接中..")
                    break
                }
            }
        }
        
        //        TODO 可能丢失
        //        TODO 另一个线程
    }
    
    /// 连接成功的处理
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("连接成功 \(String(describing: peripheral.name))")
        peripheral.discoverServices(nil)
        //            TODO: services list uuid
    }
    
    // Handles discovery event
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == BLE_Punchcard_Main_Service_CBUUID {
                    print("Main Service founded.")
                    
                    message.addString("找到 Service")
                    // Now kick off discovery of characteristics
                    //                    TODO
                    peripheral.discoverCharacteristics(nil, for: service)
                    break
                }
            }
        }
    }
    
    // Handling discovery of characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == BLE_Punchcard_Notify_Characterristic_CBUUID {
                    print("Notify Characteristic founded.")
                    self.peripheralManager.setNotifyValue(true, for: characteristic)
                    message.addString("通知特征找到，订阅成功")
                } else if characteristic.uuid == BLE_Punchcard_Write_Characterristic_CBUUID {
                    NSLog("写特征找到，订阅成功")
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == BLE_Punchcard_Notify_Characterristic_CBUUID {
            if let messageData = characteristic.value {
                message.addString("收到数据：")
                message.addString(String(data: messageData, encoding: .utf8) ?? "None")
            }
        }
    }
    
}

extension String {
    mutating func addString(_ str: String) {
        self = self + str + "\n"
    }
}
