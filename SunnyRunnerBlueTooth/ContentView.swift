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
                    Text("蓝牙数据")
            }
            .tag(1)
            
            DataView()
                .tabItem {
                    Image(systemName: "rosette")
                    Text("记录")
            }
            .tag(2)
            
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "book")
                    Text("公告资讯")
            }
            .tag(2)
            
            LoginView(username: "", password: "")
                .tabItem {
                    Image(systemName: "rectangle.stack.person.crop")
                    Text("个人中心")
            }
            .tag(3)
            
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
