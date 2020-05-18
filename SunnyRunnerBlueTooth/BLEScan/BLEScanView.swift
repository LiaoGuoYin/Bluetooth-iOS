//
//  BLEScanView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct BLEScanView: View {
    @ObservedObject var BLEConnection = BLEManager.shared
    //    @ObservedObject var BLEMessage: String = BLEManager.shared.message
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                BLEIconView()
                    .frame(width: geometry.size.width, height: geometry.size.height / 2)
                    .navigationBarTitle("BLE Devices")
                    .onTapGesture {
                        self.BLEConnection.centralManager.scanForPeripherals(withServices: nil, options: nil)
                }
                
                //                ScrollView {
                //                    Text("\(self.BLEConnection.message)")
                //                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                //                }
                //                .foregroundColor(Color.white)
                //                .padding()
                //                .background(Color(.systemRed))
                
                Section(header: Text("扫描到附近 \(self.BLEConnection.scannedBLEDevices.count) 个长跑蓝牙计步器").padding()) {
                    List(self.BLEConnection.scannedBLEDevices, id: \.self) { device in
                        ImageAndTextView(imageName: "dot.radiowaves.right", textName: "\(device.name ?? "unknown")")
                    }
                }
            }
            .padding()
        }
    }
}

struct BlueScanView_Previews: PreviewProvider {
    static var previews: some View {
        BLEScanView()
    }
}
