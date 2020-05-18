//
//  TodayDataCell.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TodayDataCell: View {
    @State var name: String
    @State var data: String
    @State var dataConsult: String
    
    var activityStatus = ["静息", "运动"]
    var activityStatusImage = ["tortoise.fill", "tortoise.fill"]
    var currentActivityStatusType: CurrentActivityStatusType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text(self.name)
                .font(.headline)
                .bold()
            
            Circle()
                .stroke(lineWidth: 0.01)
                .overlay(
                Text("\(self.data)")
                    .font(.system(size: 24, weight: .bold, design: Font.Design.monospaced))
                    .padding()
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("状态").foregroundColor(Color.white.opacity(0.8))
                HStack {
                    Text("\(self.activityStatus[0])状态").bold()// TODO data bound
                    Image(systemName: self.activityStatusImage[0])
                        .foregroundColor(Color.white)
                }
                
                Text("参考范围").foregroundColor(Color.white.opacity(0.8))
                Text(self.dataConsult).bold()
            }
        }
        .foregroundColor(.white)
        .padding(.vertical)
        .padding()
        .background(
            Rectangle().foregroundColor(Color(.systemBlue))
                .cornerRadius(16)
        )
        .shadow(radius: 5)
    }
}

struct DataBlock_Previews: PreviewProvider {
    static var previews: some View {
        TodayDataCell(name: "温度", data: "28.4 摄氏度", dataConsult: "36.0-37.3 摄氏度", currentActivityStatusType: .silence)
    }
}

enum CurrentActivityStatusType {
    case silence // 静息
    case sport // 运动
}
