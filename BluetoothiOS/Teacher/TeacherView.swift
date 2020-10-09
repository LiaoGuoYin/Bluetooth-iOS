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
    @State var isShowAlert: Bool = false
    
    var body: some View {
        TabView {
            TeacherCourseView(viewModel: TeacherCourseViewModel(teachNumber: viewModel.form.username))
                .tabItem { Image(systemName: "tag.fill") }.tag(0)
            
            NavigationView {
                List(viewModel.signAppealList.reversed(), id: \.id) { record in
                    SignAppealRowView(sign: record)
                        .padding(6)
                        .onTapGesture(count: 1, perform: {
                            self.viewModel.tappedAppealSignRecordId = record.id
                            self.isShowAlert.toggle()
                        })
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("申诉记录"), displayMode: .large)
                .navigationBarItems(leading: refreshSignAppealButton)
            }
            .onAppear(perform: viewModel.refreshRemoteSignAppealList)
            .tabItem { Image(systemName: "arrow.up.doc.on.clipboard") }.tag(1)
            
            NavigationView {
                List(viewModel.signList.reversed(), id: \.id) { record in
                    SignListRowView(sign: record)
                        .padding(6)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("考勤记录"), displayMode: .large)
                .navigationBarItems(leading: refreshSignListButton, trailing: exitButton)
            }
            .tabItem { Image(systemName: "square.and.at.rectangle") }.tag(2)
        }
        .alert(isPresented: $isShowAlert, content: {
            if ((viewModel.signAppealList.filter { $0.id == viewModel.tappedAppealSignRecordId }.first?.status) == true) {
                return Alert(title: Text("已审核，无需处理"))
            } else {
                return Alert(title: Text("是否通过申请"),
                             primaryButton:  Alert.Button.destructive(Text("取消")), secondaryButton: Alert.Button.default(Text("通过"), action: {
                                viewModel.processSignAppeal()
                                self.viewModel.refreshRemoteSignAppealList()
                             }))
            }
        })
    }
    
    var exitButton: some View {
        Button(action: {viewRouter.isLogined.toggle()}) {
            Text("退出登录")
        }
    }
    
    var refreshSignListButton: some View {
        Button(action: self.viewModel.refreshRemoteSignList) {
            Text("刷新")
        }
    }
    
    var refreshSignAppealButton: some View {
        Button(action: self.viewModel.refreshRemoteSignAppealList) {
            Text("刷新")
        }
    }
}

struct TeacherView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherView(viewModel: LoginViewModel(form: LoginUser(username: "0002", password: "lntu")))
            .environmentObject(ViewRouter())
    }
}
