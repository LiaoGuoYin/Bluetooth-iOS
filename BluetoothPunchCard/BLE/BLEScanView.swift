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
        GeometryReader { geometry in
            VStack {
                BLEIconView()
                    .frame(width: geometry.size.width, height: geometry.size.height / 2)
                    .onTapGesture {
                        self.BLEConnection.switchCentralManager()
//                        self.BLEConnection.startCentralManager()
                }
                
                Section(header: Text("扫描到附近 \(self.BLEConnection.scannedBLEDevices.count) 个长跑蓝牙计步器")
                        .foregroundColor(Color.gray)
                        .padding()
                ) {
                    List(self.BLEConnection.scannedBLEDevices, id: \.self) { device in
                        ImageAndTextView(imageName: "dot.radiowaves.right", textName: "\(device.name ?? "unknown")")
                    }
                }
                
                ScrollView {
                    Text("\(self.BLEConnection.message)")
                        .frame(width: geometry.size.width)
                }
                .foregroundColor(Color.white)
                .padding()
                .background(Color(.systemBlue).cornerRadius(8))
                .onLongPressGesture {
                    self.BLEConnection.centralManager
                }
                
            }
            .padding()
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct BLEScanView_Previews: PreviewProvider {
    static var previews: some View {
        BLEScanView()
    }
}

