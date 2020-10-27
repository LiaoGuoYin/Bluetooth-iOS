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

let GBK_ENC_RAWVALUE = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
let UTF8_ENC_RAWVALUE = String.Encoding.utf8.rawValue
let USING_ENC = GBK_ENC_RAWVALUE

class BLEManager: NSObject, ObservableObject {
    
    @Published var message: String = "初始化成功，可以开始扫描。\n"
    @Published var mode: BLEMode = BLEMode.disconnected
    @Published var scannedBLEDeviceSet: Set<CBPeripheral> = Set()
    @Published var isOn: Bool = false {
        didSet {
            switchMode()
        }
    }
    @Published var toConnectedDeviceName = "NBee" {
        didSet {
            self.startScan()
        }
    }
    
    @Published var teacherNumber: String = "0002"
    @Published var courseName: String = "DEMO"
    @Published var isUploaded: Bool = false
    
    var discoveredDevicesCount: Int {
        self.scannedBLEDeviceSet.count
    }
    
    static let shared = BLEManager()
    var centralManager: CBCentralManager! = nil
    var peripheralManager: CBPeripheral! = nil
    private var receivedData = Data()
    var dataToSendIndex: Int = 0
    
    var connectedWriteCharacteristic: CBCharacteristic?
    var connectedNotifyCharacteristic: CBCharacteristic?
    
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
}

extension BLEManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    /// 检测蓝牙状态
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message = ""
        switch (central.state) {
        case .poweredOff:
            message = "蓝牙尚未未开启"
        case .poweredOn:
            message.addString("自检成功，可以开始扫描")
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

        // 自动连接指定前缀的蓝牙设备
        if let peripheralName = peripheral.name {
            guard peripheralName.hasPrefix("NBee") else {
                return
            }
            scannedBLEDeviceSet.update(with: peripheral)
            if peripheralName == toConnectedDeviceName {
                self.peripheralManager = peripheral
                self.peripheralManager.delegate = self
                self.centralManager.connect(peripheral, options: nil)
            }
        }
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
                    self.connectedNotifyCharacteristic = characteristic
                } else if characteristic.uuid == WRITE_CBUUID {
                    self.connectedWriteCharacteristic = characteristic
                    message.addString("写特征找到，可以开始发送数据")
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
    
    /// 读外设数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == NOTIFY_CBUUID {
            if let actualData = characteristic.value {
                receivedData.append(actualData)
                if let tmpString = String(data: actualData, encoding: String.Encoding(rawValue: USING_ENC)) {
                    if tmpString.contains("MAC") {
                        receivedData = Data()
                        receivedData.append(actualData)
                    } else if (tmpString.contains("end")) {
                        if let outputString = String(data: receivedData, encoding: String.Encoding(rawValue: USING_ENC)) {
                            message.addString("收到数据：\r\n\(outputString)")
                            uploadRecord(studentListString: outputString, teacherNumber: teacherNumber, courseName: courseName)
                            isUploaded = true
                            receivedData = Data()
                        }
                    }
                }
            }
        }
    }
    
    /// 向外设写入数据之后的回调
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

extension BLEManager {
    /// 开始扫描
    func startScan() {
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        message.addString("初始化成功，开始扫描：设备名为 NBee 开头的蓝牙考勤设备")
    }
    
    /// 关闭扫描
    func stopScan() {
        self.disConnect()
        self.centralManager.stopScan()
        message.addString("关闭扫描")
    }
    
    /// 断开连接
    func disConnect() {
        if self.peripheralManager == nil {
            return
        }
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
            self.toConnectedDeviceName = "NBee"
            self.stopScan()
            self.mode = .disconnected
        }
    }
    
    /// 将待发送数据分包，并发送分包后的数据
    func sendDataToDevice(sendString: String, _ characteristic: CBCharacteristic) {
        var sendCount = 0
        
        // 检查是否持有蓝牙连接
        guard (peripheralManager != nil) else { return }
        
        while ((1) != 0) {
            if dataToSendIndex >= sendString.count {
                dataToSendIndex = 0
                break
            }
            
            var amountToSend = sendString.count - dataToSendIndex
            amountToSend = min(110, amountToSend)
            let subSendString = sendString[dataToSendIndex..<(dataToSendIndex + amountToSend)]
            
            let chunk = subSendString.data(using: String.Encoding(rawValue: USING_ENC))
            guard (chunk != nil) else { return }
            print("Sent \(chunk!.count) String: \(String(subSendString))")
            sendCount = sendCount + 1
            runDelay(0.02) {
                self.peripheralManager.writeValue(chunk!, for: characteristic, type: .withResponse)
            }
            dataToSendIndex += amountToSend
        }
    }
    
    /// 异步分包发送
    func runDelay(_ delay:TimeInterval,_ block:@escaping () -> ()) {
        let queue = DispatchQueue.main
        let delayTime = DispatchTime.now() + delay
        queue.asyncAfter(deadline: delayTime) {
            block()
        }
    }
    
    /// 上传考勤记录
    func uploadRecord(studentListString: String, teacherNumber: String, courseName: String) {
        let studentList = deSerializingReceivedStudentsStringToArray(receivedString: studentListString)
        message.addString(studentList.description)
        let course = CourseRecord(teacherNumber: teacherNumber, courseName: courseName, signList: studentList)
        APIClient.teacherUploadCourse(course) { (result) in
            switch result {
            case .failure(let error):
                self.message.addString(error.localizedDescription)
            case .success(let response):
                self.message.addString(response.msg)
            }
        }
    }
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
    
    mutating func addString(_ str: String) {
        NSLog(str)
        self = self + str + "\n"
    }
}

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
}

enum BLEMode {
    case disconnected
    case connected
}
