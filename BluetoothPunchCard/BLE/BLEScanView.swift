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
    
    var body: some View {
        VStack {
            BLEIconView().onTapGesture {
                self.BLEConnection.stopScanButton()
            }
            .frame(height: 200)
            .padding()
            
            Section(header: Text("扫描到附近 \(self.BLEConnection.scannedBLEDevices.count) 个考勤机")
                        .foregroundColor(Color.gray)) {
                List(self.BLEConnection.scannedBLEDevices, id: \.self) { device in
                    HStack {
                        Image(systemName: "wave.3.right")
                        Text(device.name ?? "UNKNOWN")
                    }
                }
            }
            
            Section(header:HStack {
                            Text("Console")
                                .underline()
                                .foregroundColor(Color(.systemPink))
                                .bold()
                                .padding(.horizontal)
                            Spacer()}
            ) {
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
}

struct BLEScanView_Previews: PreviewProvider {
    static var previews: some View {
        BLEScanView()
    }
}

