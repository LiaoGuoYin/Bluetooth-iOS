//
//  ContentView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BLEScanView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("蓝牙")
            }
            .tag(1)
            
            TodayDataView()
                .tabItem {
                    Image(systemName: "rosette")
                    Text("数据")
            }
            .tag(2)
            
            NoticeView(noticeItem: NoticeItem(noticeList: noticeSample.data!))
                .tabItem {
                    Image(systemName: "book")
                    Text("资讯")
            }
            .tag(3)
            
            LoginView()
                .tabItem {
                    Image(systemName: "rectangle.stack.person.crop")
                    Text("个人")
            }
            .tag(4)
            
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
