//
//  BLEIconView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct BLEIconView: View {
    @State private var showOuterWave = false
    @State private var innerOuterWave = false
    
    var body: some View {
        ZStack {
            //            OuterWave
            Circle()
                .stroke()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                .scaleEffect(showOuterWave ? 2.6 : 1)
                .opacity(showOuterWave ? 0.5 : 1)
                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
                .onAppear() {
                    self.showOuterWave.toggle()
            }

            //            InnerWave
            Circle()
                .stroke()
                .frame(width: 100, height: 100)
                .foregroundColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                .scaleEffect(innerOuterWave ? 2.2 : 1)
                .opacity(innerOuterWave ? 0.5 : 1)
                .animation(Animation.easeInOut(duration: 1).delay(1).repeatForever(autoreverses: true).delay(2))
                .onAppear() {
                    self.innerOuterWave.toggle()
            }
            
            Circle()
                .frame(width: 160, height: 160)
                .foregroundColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
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

