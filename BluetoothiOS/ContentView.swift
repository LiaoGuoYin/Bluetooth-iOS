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
            TeacherCourseView()
                .tabItem {
                    Image(systemName: "tag.fill")
                    Text("Record")
                }
            
            LoginView()
                .tabItem {
                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                    Text("Account")
                }
            
            AccountView()
                .tabItem {
                    Image(systemName: "rectangle.stack.person.crop.fill")
                    Text("Account")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
