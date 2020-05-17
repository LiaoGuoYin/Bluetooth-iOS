//
//  DataView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct DataView: View {
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    HStack {
                        DataBlock(name: "时下 HeartBeat", data: "82 BPM", dataConsult: "59 - 96 BPM", currentActivityStatusType: .silence)
                        
                        DataBlock(name: "时下 Temperature", data: "28.4 ℃", dataConsult: "36.0 - 37.3 ℃", currentActivityStatusType: .silence)
                    }
                    
                    HStack {
                        DataBlock(name: "Step 合计", data: "14 STEPS", dataConsult: "0+ Steps", currentActivityStatusType: .silence)
                        
                        DataBlock(name: "Distance 合计", data: "88 METERS", dataConsult: "0+ Meters", currentActivityStatusType: .silence)
                    }
                }
                .navigationBarTitle(Text("实时蓝牙数据"), displayMode: .automatic)
                
                Text("最近一次更新：30s 前")
                    .font(.caption)
                    .padding()
                    .shadow(radius: 10)
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
