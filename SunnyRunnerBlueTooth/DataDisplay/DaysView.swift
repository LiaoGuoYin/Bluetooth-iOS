//
//  DaysView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/17.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct DaysView: View {
    var body: some View {
        List(0 ..< 3) { item in
            VStack(spacing: 16) {
                DayView(data: DayData(date: "2020.5.18", time: "8:35", distance: 88, step: 64, heartBeat: 83))
                DayView(data: DayData(date: "2020.5.17", time: "23:35", distance: 8900, step: 6980, heartBeat: 83))
                DayView(data: DayData(date: "2020.5.16", time: "23:05", distance: 8900, step: 6480, heartBeat: 79))
                DayView(data: DayData(date: "2020.5.15", time: "23:45", distance: 5064, step: 4933, heartBeat: 81))
                DayView(data: DayData(date: "2020.5.14", time: "23:55", distance: 564, step: 433, heartBeat: 79))
            }
        }
        .navigationBarTitle(Text("历史数据"))
        .onAppear {
            UITableView.appearance().separatorStyle = .none
        }
    }
}

struct DaysView_Previews: PreviewProvider {
    static var previews: some View {
        DaysView()
    }
}
