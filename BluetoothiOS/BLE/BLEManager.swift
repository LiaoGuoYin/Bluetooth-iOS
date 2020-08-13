//
//  BLEManager.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/16.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import CoreBluetooth

let MAIN_SERVICEUUID = CBUUID(string: "0xFFE1") // Main service
let NOTIFY_CBUUID = CBUUID(string: "0xFFE2") // Notify characteristic
let WRITE_CBUUID = CBUUID(string: "0xFFE3") // Write characteristic

class BLEManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate, ObservableObject {
    @Published var message: String = "初始化成功，可以开始扫描。\n"
    @Published var scannedBLEDevices: [CBPeripheral] = []
    @Published var mode: BLEMode = BLEMode.disconnected
    @Published var isOn: Bool = false {
        didSet {
            switchMode()
        }
    }
    
    static let shared = BLEManager()
    var centralManager: CBCentralManager! = nil
    var peripheralManager: CBPeripheral! = nil
    private var dataToSend = Data()
    private var receiveData = Data()
    var sendDataIndex: Int = 0
    
    
    // 自动连接的蓝牙前缀
    var names = ["NBee_BLE1E1802", "LGY"]
    
    override init() {
        super.init()
        startCentralManager()
    }
    
    /// 初始化
    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        NSLog("初始化成功")
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
            message.addString("自检成功，可以开始扫描")
        //            self.startScan()
        // TODO 扫描指定 Service
        //                self.centralManager.scanForPeripherals(withServices: [BLEConnection.bleServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
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
        
        // 自动连接指定前缀的蓝牙设备
        if let peripheralName = peripheral.name {
            for name in names {
                if peripheralName.hasPrefix(name) {
                    self.peripheralManager = peripheral
                    self.peripheralManager.delegate = self
                    self.centralManager.connect(peripheral, options: nil)
                    break
                }
            }
        }
        // TODO 其他连接方式
        // TODO 可能丢失。另一个线程
    }
    
    /// 连接状态变化
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        //        message.addString("扫描 Services 中")
    }
    
    /// 连接成功，扫描 Services
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        message.addString("连接成功：\(String(describing: peripheral.name))")
        self.centralManager.stopScan()
        self.mode = BLEMode.connected
        peripheral.discoverServices(nil)
    }
    
    /// 发现 Services，扫描下属的 Characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // 找到指定 Service
        if let services = peripheral.services {
            for service in services {
                if service.uuid == MAIN_SERVICEUUID {
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
                if characteristic.uuid == NOTIFY_CBUUID {
                    self.peripheralManager.setNotifyValue(true, for: characteristic)
                } else if characteristic.uuid == WRITE_CBUUID {
                    sendDataToDevice(sendString: sendStringDemo, characteristic)
                    message.addString("写特征找到，发送成功")
                }
            }
        }
    }
    
    /// 订阅 Characteristic 回调
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let actualError = error {
            print("订阅过程遇到一点错误: \(actualError)")
        }
        message.addString("通知特征找到，订阅成功")
    }
    
    /// 读/写外设数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == NOTIFY_CBUUID {
            if let actualData = characteristic.value {
                receiveData.append(actualData)
                //                NSLog(actualData as NSData)
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
                if let tmpString = String(data: actualData, encoding: String.Encoding(rawValue: enc)) {
                    if (tmpString.contains("end")) {
                        // 收到表尾：end
                        if let outputString = String(data: receiveData, encoding: String.Encoding(rawValue: enc)) {
                            message.addString("收到数据2：\(outputString)")
                            print("*****************")
                            print(outputString)
                            receiveData = Data()
                        }
                    }
                }
            }
        }
    }
    
    /// 检测向外设写入数据是否成功
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let actualError = error {
            message.addString("写数据失败\(actualError)")
        }
    }
    
    /// 断开设备
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        message.addString("断开设备：\(String(describing: peripheral.name))")
    }
    
}

extension String {
    mutating func addString(_ str: String) {
        NSLog(str)
        self = self + str + "\n"
    }
}

extension BLEManager {
    /// 开始扫描
    func startScan() {
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        message.addString("初始化成功，开始扫描")
    }
    
    /// 关闭扫描
    func stopScan() {
        self.disConnect()
        self.centralManager.stopScan()
        message.addString("关闭扫描")
    }
    
    /// 断开连接
    func disConnect() {
        if self.peripheralManager.state.rawValue == 0 {
            return
        }
        self.centralManager.cancelPeripheralConnection(peripheralManager)
        message.addString("断开连接！")
    }
    
    /// 切换模式
    func switchMode() {
        switch self.mode {
        case .disconnected:
            self.startScan()
            self.mode = .connected
        case .connected:
            self.scannedBLEDevices.removeAll()
            self.stopScan()
            self.mode = .disconnected
        }
    }
    
    /// 将待发送数据分包，并发送分包后的数据
    func sendDataToDevice(sendString: String, _ characteristic: CBCharacteristic) {
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        if let EncodedData = sendString.data(using: String.Encoding(rawValue: enc)) {
            dataToSend = EncodedData
        }
        
        guard (peripheralManager != nil) else {
            return
        }
        
//        while (1 != 0) {
//            if sendDataIndex >= dataToSend.count {
//                sendDataIndex = 0
//                break
//            }
//
//            var amountToSend = dataToSend.count - sendDataIndex
//            let mtu = peripheralManager.maximumWriteValueLength(for: .withoutResponse)
//            amountToSend = min(amountToSend, mtu)
//
//            let chunk = dataToSend.subdata(in: sendDataIndex..<(sendDataIndex + amountToSend))
//            let stringFromData = String(data: chunk, encoding: String.Encoding(rawValue: enc))
//            print("Sent %d bytes: %s", chunk.count, String(describing: stringFromData))
//            runDelay(0.02) {
//                self.peripheralManager.writeValue(chunk, for: characteristic, type: .withoutResponse)
//            }
//
//            sendDataIndex += amountToSend
        
        for index in 0...dataToSend.count - 1 {
            let chunk = dataToSend.subdata(in: index..<(index+1))
            runDelay(0.01 * Double(index)) {
                self.peripheralManager.writeValue(chunk, for: characteristic, type: .withoutResponse)
            }
        }
    }
    
    /// 分片输出
    func runDelay(_ delay:TimeInterval,_ block:@escaping () -> ()) {
        let queue = DispatchQueue.main
        let delayTime = DispatchTime.now() + delay
        queue.asyncAfter(deadline: delayTime) {
            block()
        }
    }
    
}

enum BLEMode {
    case disconnected
    case connected
}

var sendStringDemo: String = """
姓名,班级,学号,MAC,
欧珀,电信研181,471820336,4c1a3d493e6c,
吴埃斯,电信研183,123456778,BCE143B46210,
吴一帆,工商研183,123456789,7836CC44578C,
杨清雷,土木研183,234567890,3CA581792440,
张世晔,英语研183,345678901,D461DA37FC98,
霍泽生,数学研183,456789112,A4504689B81F,
吕英鑫,工管研183,123231132,9487E09F9B02,
初殿宇,法学研183,234563457,A4933F817F83,
刘埃斯,工商研184,225039186,044BED769B5E,
方彦瑾,安全研183,345678922,9CE82B8128AC,
铁牛,电控研181,863487827,4404446AA450,
袁超,安全研183,683268688,482CA03CDEB7,
唐玉莲,工管研183,671256411,F4BF8008D846,
周雪,财贸研183,67136728,047970E090B6,
潘佳欣,法学研183,315263533,A4933F818390,
皮克嗖,英语研185,527737383,B4F1DA9A361D,
维沃,机械研182,352033185,488764443630,
十一,电信研188,342708190,B87BC5C6303B,
end
"""
