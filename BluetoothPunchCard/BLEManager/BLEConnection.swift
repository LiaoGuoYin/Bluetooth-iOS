//
//  BLEConnection.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/16.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth


let BLE_Punchcard_Main_Service_CBUUID = CBUUID(string: "0xFFE1") // Main
let BLE_Punchcard_Notify_Service_CBUUID = CBUUID(string: "0xFFE2") // Notify
let BLE_Punchcard_Write_Service_CBUUID = CBUUID(string: "0xFFE3") // Write

let BLE_Punchcard_transfer_Characterristic_CBUUID = CBUUID(string: "0xFFE4") // Transfer file

open class BLEConnection: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate, ObservableObject {
    
    // BLEConnection 单例
    static let shared = BLEConnection()
    
    // 设备扫描到的蓝牙，回写到 SwiftUI View
    @Published var scannedBLEDevices: [CBPeripheral] = []
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.centralManagerDidUpdateState(self.centralManager)
        }
    }
    
    /// 检测本机蓝牙状态
    /// - Parameter central: 蓝牙状态管理实例
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message: String! = ""
        switch (central.state) {
        case .poweredOff:
            message = "poweredOff"
        case .poweredOn:
            print("Central is scanning for: ", BLE_Punchcard_Main_Service_CBUUID);
            //            self.centralManager.scanForPeripherals(withServices: [BLEConnection.bleServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            message = "resetting"
        case .unauthorized:
            switch central.authorization {
            case .allowedAlways:
                message = "OK"
            case .denied:
                message = "denied"
            case .restricted:
                message = "restricted"
            case .notDetermined:
                message = "Not Determined"
            @unknown default:
                message = "unknown"
            }
        case .unknown:
            message = "unknown yes"
        case .unsupported:
            message = "unsupported"
        @unknown default:
            message = "unknown"
        }
        print(message as String)
    }
    
    /// 处理外设扫描结果
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    ///   - advertisementData: advertisementData description
    ///   - RSSI: RSSI description
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        print("New discovery! Peripheral Name: \(String(describing: peripheral.name))  RSSI: \(String(RSSI.doubleValue))")
        
        self.centralManager.stopScan()
        print(peripheral.name ?? "unknown")
        self.scannedBLEDevices.append(peripheral)
        self.peripheralManager = peripheral
        self.peripheralManager.delegate = self
        
        print(self.scannedBLEDevices)
        
        // Connect!
        //        self.centralManager.connect(self.peripheral, options: nil)
    }
    
    /// 连接成功的处理
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheralManager {
            print("Connected to your BLE Board")
            peripheral.discoverServices([
                BLE_Punchcard_Main_Service_CBUUID,
                BLE_Punchcard_Notify_Service_CBUUID,
                BLE_Punchcard_Write_Service_CBUUID])
        }
    }
    
    // Handles discovery event
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == BLE_Punchcard_Main_Service_CBUUID {
                    print("BLE Service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics(nil, for: service)
                    return
                }
            }
        }
    }
    
    // Handling discovery of characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == BLE_Punchcard_transfer_Characterristic_CBUUID {
                    print("BLE service characteristic found!")
                } else {
                    print("Characteristic not found.")
                }
            }
        }
    }
    
}
