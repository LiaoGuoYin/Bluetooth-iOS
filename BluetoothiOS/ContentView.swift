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
            if viewRouter.userType == UserType.admin {
                AdminView(viewModel: AdminViewModel())
                    .environmentObject(viewRouter)
            } else if viewRouter.userType == UserType.teacher {
                TeacherView(viewModel: loginViewModel)
                    .environmentObject(viewRouter)
            } else {
                AccountView(loginViewModel: loginViewModel)
                    .environmentObject(viewRouter)
                    .tabItem {
                        Image(systemName: "rectangle.stack.person.crop.fill")
                        Text("Account")
                    }
            }
        } else {
            VStack {
                LoginView(viewModel: self.loginViewModel)
                    .environmentObject(viewRouter)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
