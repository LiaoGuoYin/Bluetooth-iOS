//
//  BLEIconView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/17.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct BLEIconView: View {
//    @State private var showOuterWave = true
//    @State private var innerOuterWave = true
    var isScanning = BLEManager.shared.isScanning
    
    var body: some View {
        ZStack {
//            //            OuterWave
//            Capsule()
//                .stroke()
//                .frame(width: 90, height: 120)
//                .scaleEffect(showOuterWave ? 2.2 : 1)
//                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
//                .foregroundColor(Color(.systemBlue))
//                .onAppear {
//                    self.showOuterWave.toggle()
//                }
//                .opacity((isScanning ? 1 : 0))
            
            //            InnerWave
//            Capsule()
//                .stroke()
//                .frame(width: 70, height: 100)
//                .scaleEffect(innerOuterWave ? 2 : 1)
//                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
//                .foregroundColor(Color(.systemBlue))
//                .onAppear {
//                    self.innerOuterWave.toggle()
//                }
//                .opacity((isScanning ? 1 : 0))
            
            Capsule()
                .frame(width: 100, height: 160)
                .foregroundColor((self.isScanning ? Color(.systemBlue):Color(.systemGray)))
                .shadow(radius: 8)
            
            
            Image("bluetoothIcon")
                .font(.largeTitle)
            
//            Capsule()
//                .frame(width: 80, height: 100)
//                .foregroundColor((self.isScanning ? Color(.systemBlue):Color(.systemGray)))
            
        }
        .animation(.spring())
    }
}

struct BLEIconView_Previews: PreviewProvider {
    static var previews: some View {
        BLEIconView()
    }
}
