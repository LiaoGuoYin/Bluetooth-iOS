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
    @State var loginViewModel = LoginViewModel(form: LoginUser(username: "", password: ""))
    
    var body: some View {
        if viewRouter.isLogined {
            if viewRouter.userType == UserType.student {
                AccountView(loginViewModel: self.loginViewModel)
                    .environmentObject(viewRouter)
                    .tabItem {
                        Image(systemName: "rectangle.stack.person.crop.fill")
                        Text("Account")
                    }
            } else {
                TabView {
                    TeacherCourseView(viewModel: TeacherCourseViewModel(teachNumber: loginViewModel.form.username))
                        .tabItem {
                            Image(systemName: "tag.fill")
                            Text("Record")
                        }
                    
                    AccountView(loginViewModel: self.loginViewModel)
                        .environmentObject(viewRouter)
                        .tabItem {
                            Image(systemName: "rectangle.stack.person.crop.fill")
                            Text("Account")
                        }
                }
            }
            
        } else {
            LoginView(viewModel: self.loginViewModel).environmentObject(viewRouter)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
