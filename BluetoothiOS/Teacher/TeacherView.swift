//
//  TeacherView.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/27.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI


struct TeacherView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State var viewModel: LoginViewModel
    
    var body: some View {
        TabView {
            TeacherCourseView(viewModel: TeacherCourseViewModel(teachNumber: viewModel.form.username))
                .tabItem { Image(systemName: "tag.fill") }
            
            NavigationView {
                List(viewModel.signList, id: \.id) { record in
                    SignListRowView(sign: record)
                        .accentColor(.pink)
                        .padding(6)
                }
                .navigationBarTitle(Text("考勤记录"), displayMode: .large)
                .navigationBarItems(leading: refreshSignButton, trailing: exitButton)
                .onAppear(perform: viewModel.refreshRemoteSignList)
            }
            .tabItem { Image(systemName: "square.and.at.rectangle") }
        }
        .accentColor(.pink)
    }
    
    var exitButton: some View {
        Button(action: {viewRouter.isLogined.toggle()}) {
            Text("退出登录")
                .padding(8)
        }
    }
    
    var refreshSignButton: some View {
        Button(action: self.viewModel.refreshRemoteSignList) {
            Text("刷新")
        }
    }
}

struct TeacherView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherView(viewModel: LoginViewModel(form: LoginUser(username: "0001", password: "")))
            .environmentObject(ViewRouter())
    }
}
