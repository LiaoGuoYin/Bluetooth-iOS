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
        } else {
            message.addString("Write data to device successfully")
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
        guard (peripheralManager != nil) else { return }
        
        print( peripheralManager.maximumWriteValueLength(for: .withResponse))
        print( peripheralManager.maximumWriteValueLength(for: .withoutResponse))
        var sendCount = 0
        
        while ((1) != 0) {
            if sendDataIndex >= sendString.count {
                sendDataIndex = 0
                break
            }
            
            var amountToSend = sendString.count - sendDataIndex
            amountToSend = min(130, amountToSend)
            let subSendString = sendString[sendDataIndex..<(sendDataIndex + amountToSend)]
            
            let chunk = subSendString.data(using: String.Encoding(rawValue: enc))
            guard (chunk != nil) else { return }
            print("Sent \(chunk!.count) String: \(String(subSendString))")
            sendCount = sendCount + 1
            runDelay(0.02) {
                self.peripheralManager.writeValue(chunk!, for: characteristic, type: .withResponse)
            }
            
            sendDataIndex += amountToSend
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

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}

var sendStringDemo: String = """
姓名,班级,学号,MAC,\r
丁一,111,1,BCE143B46210,√\r
吴一帆,183,2,7836CC44578C,\r
杨清雷,183,3,3CA581792440,\r
张世晔,183,4,D461DA37FC98,\r
霍泽生,183,5,A4504689B81F,\r
吕英鑫,183,6,9487E09F9B02,\r
初殿宇,183,7,A4933F817F83,\r
方彦瑾,183,8,9CE82B8128AC,\r
铁牛,181,9,4404446AA450,√\r
袁超,183,10,482CA03CDEB7,\r
唐玉莲,183,11,F4BF8008D846,\r
周雪,183,12,047970E090B6,\r
潘佳欣,183,13,A4933F818390,\r
尹亭月,183,14,2CA9F00BE204,\r
扈健民,183,15,9CE82B98AB50,\r
黄小龙,183,16,B894363C32D0,\r
郭勇,183,17,0479709D53C0,\r
冯凯浩,183,18,4CD1A1DA0104,\r
饶明钊,183,19,9487E0B6498A,\r
由广昊,183,134,af2536cdbbe66,\r
陈鑫,183,135,af2536cdbbe67,\r
王伟,183,136,af2536cdbbe68,\r
由广昊,183,137,af2536cdbbe69,\r
陈鑫,183,138,af2536cdbbe70,\r
王伟,183,139,af2536cdbbe71,\r
王伟,183,140,af2536cdbbe72,\r
由广昊,183,141,af2536cdbbe73,\r
陈鑫,183,142,af2536cdbbe74,\r
王伟,183,143,af2536cdbbe75,\r
由广昊,183,144,af2536cdbbe76,\r
陈鑫,183,145,af2536cdbbe77,\r
王伟,183,146,af2536cdbbe78,\r
王伟,183,147,af2536cdbbe79,\r
由广昊,183,148,af2536cdbbe80,\r
陈鑫,183,149,af2536cdbbe81,\r
王伟,183,150,af2536cdbbe82,\r
由广昊,183,151,af2536cdbbe83,\r
陈鑫,183,152,af2536cdbbe84,\r
王伟,183,153,af2536cdbbe85,\r
王伟,183,154,af2536cdbbe86,\r
由广昊,183,155,af2536cdbbe87,\r
陈鑫,183,156,af2536cdbbe88,\r
end\r
"""
