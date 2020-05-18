//
//  DaysView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/17.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct DayView: View {
    @State var data: DayData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                DayDetailView(itemName: "总距离", itemUnit: "米", itemData: data.distance)
                Spacer()
                DayDetailView(itemName: "总步数", itemUnit: "步", itemData: data.step)
                Spacer()
                DayDetailView(itemName: "平均心率", itemUnit: "BPM", itemData: data.heartBeat)
            }
            
            HStack {
                Spacer()
                Text(data.date)
                Text(data.time) + Text("   >")
            }
            .font(.subheadline)
        }
        .foregroundColor(Color.white)
        .padding()
        .background(Color(.systemBlue))
        .cornerRadius(16)
    }
}

struct DayDetailView: View {
    var itemName: String
    var itemUnit: String
    @State var itemData: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(itemName).font(.subheadline)
            Text("\(itemData)").font(.system(size: 24, design: .monospaced)) + Text(" ") + Text(itemUnit).font(.subheadline)
        }
    }
}

struct DayData {
    var date: String
    var time: String
    
    var distance: Int
    var step: Int
    var heartBeat: Int
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(data: DayData(date: "2020.5.17", time: "21:05", distance: 8900, step: 7480, heartBeat: 83))
    }
}
