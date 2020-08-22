//
//  ContentView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/5.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BLEView()
                .tabItem {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    Text("PuncCard")
            }
            .tag(1)
            
            TeacherCourseView()
                .tabItem {
                    Image(systemName: "tag.fill")
                    Text("Record")
            }
            .tag(2)
            
            AccountView()
                .tabItem {
                    Image(systemName: "rectangle.stack.person.crop.fill")
                    Text("Account")
            }
            .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
