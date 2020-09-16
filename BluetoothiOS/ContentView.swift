//
//  ContentView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/5.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        if viewRouter.isLogined {
            TabView {
                TeacherCourseView()
                    .tabItem {
                        Image(systemName: "tag.fill")
                        Text("Record")
                    }
                
                AccountView().environmentObject(viewRouter)
                    .tabItem {
                        Image(systemName: "rectangle.stack.person.crop.fill")
                        Text("Account")
                    }
            }
        } else {
            LoginView(viewModel: LoginViewModel(form: LoginUser(username: "", password: ""))).environmentObject(viewRouter)
                .transition(.scale)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
