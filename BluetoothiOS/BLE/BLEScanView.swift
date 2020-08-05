//
//  BLEScanView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/16.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct BLEScanView: View {
    @ObservedObject var BLEConnection = BLEManager.shared
    @State private var isScanningOn: Bool = false
    
    var body: some View {
        VStack {
            Image("bluetoothIcon")
                .font(.largeTitle)
                .shadow(radius: 1)
                .background(
                    Capsule()
                        .frame(width: 80, height: 130)
                        .foregroundColor(Color(.systemBlue))
                )
                .shadow(radius: 10)
                .frame(height: 160)
                .padding()
            
            
            Toggle("蓝牙考勤机", isOn: self.$isScanningOn)
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
        BLEScanView()
    }
}


enum BLEMode {
    case scanning
    case connected
    case disconnected
}
