//
//  BLEScanView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/16.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct BLEView: View {
    
    @ObservedObject var BLEConnection = BLEManager.shared
    @State var studentList: Array<LoginResponseData>
    @State var courseName: String
    @State var teacherNumber: String
    
    var body: some View {
        NavigationView {
            VStack {
                Image("bluetoothIcon")
                    .font(.largeTitle)
                    .clipped()
                    .background(
                        Capsule()
                            .frame(width: 75, height: 120)
                            .foregroundColor(BLEConnection.isOn ? Color.blue:Color.gray)
                    )
                    .shadow(radius: 10)
                    .frame(height: 150)
                    .padding()
                
                Toggle("蓝牙考勤机", isOn: $BLEConnection.isOn)
                    .padding()
                
                Section(header: Text("扫描到附近 \(BLEConnection.discoveredDevicesCount) 个考勤机")
                            .foregroundColor(Color.gray)) {
                    List(Array(BLEConnection.scannedBLEDeviceSet), id: \.self) { device in
                        HStack {
                            Image(systemName: "wave.3.forward")
                            Text(device.name ?? "UNKNOWN")
                        }
                        .padding()
                        .onTapGesture {
                            if let actualName = device.name {
                                BLEConnection.toConnectedDeviceName = actualName
                            }
                        }
                    }
                }
                
                ScrollView {
                    HStack {
                        Text("\(self.BLEConnection.message)")
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .padding()
                        Spacer()
                    }
                }
                .frame(height: 110)
                .background(Color.blue)
            }
            .navigationBarItems(trailing: sendButton)
        }
        .banner(data: .constant(BannerModifier.Data(title: "考勤结果", content: BLEConnection.message)), isShow: $BLEConnection.isUploaded)
    }
    
    var sendButton: some View {
        Button(action: sendStudentStringToBLE ) {
            Text("发送")
                .foregroundColor(.pink)
        }
    }
    
    func sendStudentStringToBLE() {
        let studentListString = serializeStudentsToStringForSending(students: self.studentList)
        if let connectedCharacteristic = BLEManager.shared.connectedWriteCharacteristic {
            BLEManager.shared.sendDataToDevice(sendString: studentListString, connectedCharacteristic)
        } else {
            print("没有连接到蓝牙 Write Characteristic，发送数据失败")
        }
    }
}


extension BLEView {
    init(_ studentList: Array<LoginResponseData>, courseName: String, teacherNumber: String) {
        self.init(studentList: studentList, courseName: courseName, teacherNumber: teacherNumber)
        self.BLEConnection.courseName = courseName
        self.BLEConnection.teacherNumber = teacherNumber
    }
}

struct BLEScanView_Previews: PreviewProvider {
    static var previews: some View {
        BLEView(studentList: [], courseName: "DEMO", teacherNumber: "0002")
    }
}
