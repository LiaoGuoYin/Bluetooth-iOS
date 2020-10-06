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
                    .accentColor(.pink)
            } else if viewRouter.userType == UserType.teacher {
                TeacherView(viewModel: loginViewModel)
                    .environmentObject(viewRouter)
                    .accentColor(.pink)
            } else {
                StudentView(loginViewModel: loginViewModel)
                    .environmentObject(viewRouter)
            }
        } else {
            LoginView(viewModel: self.loginViewModel)
                .environmentObject(viewRouter)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
