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
    
    var body: some View {
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
                        Image(systemName: "wave.3.right")
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
    }
}

struct BLEScanView_Previews: PreviewProvider {
    static var previews: some View {
        BLEView()
    }
}
