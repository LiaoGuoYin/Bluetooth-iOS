//
//  BLEIconView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/17.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct BLEIconView: View {
    @State private var showOuterWave = true
    @State private var innerOuterWave = true
    
    var body: some View {
        ZStack {
            //            OuterWave
            Capsule()
                .stroke()
                .frame(width: 90, height: 120)
                .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                .scaleEffect(showOuterWave ? 2.6 : 1)
                .opacity(showOuterWave ? 0.5 : 1)
                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
                .onAppear {
                    self.showOuterWave.toggle()
            }
            
            //            InnerWave
            Capsule()
                .stroke()
                .frame(width: 70, height: 100)
                .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                .scaleEffect(innerOuterWave ? 2.2 : 1)
                .opacity(innerOuterWave ? 0.5 : 1)
                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
                .onAppear {
                    self.innerOuterWave.toggle()
            }
            
            Capsule()
                .frame(width: 100, height: 160)
                .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                .shadow(radius: 8)
            
            Capsule()
                .frame(width: 80, height: 100)
                .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
            
            Image("bluetoothIcon")
                .font(.largeTitle)
            
        }
    }
}

struct BLEIconView_Previews: PreviewProvider {
    static var previews: some View {
        BLEIconView()
    }
}
