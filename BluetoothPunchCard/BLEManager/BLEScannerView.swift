//
//  BLEScannerView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/17.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct BLEScannerView: View {
    @State private var showOuterWave = false
    @State private var showMiddleWare = false
    @State private var innerOuterWave = false

    var body: some View {
        ZStack {

//            OuterWave
            Circle()
                .stroke()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                .scaleEffect(showOuterWave ? 3 : 1)
                .opacity(showOuterWave ? 0.5 : 1)
                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
                .onAppear() {
                    self.showOuterWave.toggle()
            }

//            MiddleWave
            Circle()
                .stroke()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                .scaleEffect(showMiddleWare ? 2.75 : 1)
                .opacity(showMiddleWare ? 0.5 : 1)
                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
                .onAppear() {
                    self.showOuterWave.toggle()
            }

//            InnerWave
            Circle()
                .stroke()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                .scaleEffect(innerOuterWave ? 2.5 : 1)
                .opacity(innerOuterWave ? 0.5 : 1)
                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
                .onAppear() {
                    self.showOuterWave.toggle()
            }

            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
            Circle()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
            Image(systemName: "antenna.radiowaves.left.and.right")
                .foregroundColor(Color.white)
                .font(.largeTitle)

        }

    }
}

struct BLEScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BLEScannerView()
    }
}
