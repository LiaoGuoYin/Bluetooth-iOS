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
    @State var studentList: Array<LoginResponseData> = []
    
    var body: some View {
        NavigationView {
            VStack {
                Image("bluetoothIcon")
                    .font(.largeTitle)
                    .shadow(radius: 1)
                    .background(
                        Capsule()
                            .frame(width: 80, height: 130)
                            .foregroundColor(
                                self.BLEConnection.isOn ? Color.blue:Color.gray)
                    )
                    .shadow(radius: 10)
                    .frame(height: 160)
                    .padding()
                
                Toggle("蓝牙考勤机", isOn: self.$BLEConnection.isOn)
                    .padding()
                
                Section(header: Text("扫描到附近 \(self.BLEConnection.scannedBLEDevices.count) 个考勤机")
                            .foregroundColor(Color.gray)) {
                    List(self.BLEConnection.scannedBLEDevices, id: \.self) { device in
                        HStack {
                            Image(systemName: "wave.3.forward")
                            Text(device.name ?? "UNKNOWN")
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
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
                .frame(height: 160)
                .background(Color.blue)
            }
            .navigationBarItems(trailing: sendButton)
            .onDisappear(perform: {
                BLEConnection.message = "初始化成功，可以开始扫描。\n"
                BLEConnection.disConnect()
            })
        }
    }
    
    var sendButton: some View {
        Button(action: { sendStudentStringToBLE(studentList)}) {
            Text("发送")
                .foregroundColor(.pink)
        }
    }
    
    func sendStudentStringToBLE(_ studentList: Array<LoginResponseData>) {
        let studentListString = serializeStudentsToStringForSending(students: studentList)
        if let connectedCharacteristic = BLEManager.shared.connectedWriteCharacteristic {
            BLEManager.shared.sendDataToDevice(sendString: studentListString, connectedCharacteristic)
        } else {
            print("没有连接到蓝牙 Write Characteristic，发送数据失败")
        }
    }
    
}

struct BLEScanView_Previews: PreviewProvider {
    static var previews: some View {
        BLEView()
    }
}
