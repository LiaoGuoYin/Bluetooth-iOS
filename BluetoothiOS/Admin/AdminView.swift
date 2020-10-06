//
//  AdminView.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/25.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    
    @ObservedObject var viewModel: AdminViewModel
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        TabView {
            NavigationView {
                List(viewModel.signList, id: \.id) { record in
                    SignListRowView(sign: record)
                        .padding(6)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("考勤记录"), displayMode: .large)
                .navigationBarItems(leading: refreshSignListButton)
            }
            .tabItem { Image(systemName: "square.and.at.rectangle") }.tag(0)
            
            NavigationView {
                List(viewModel.signAppealList, id: \.id) { record in
                    SignAppealRowView(sign: record)
                        .padding(6)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("申诉记录"), displayMode: .large)
                .navigationBarItems(leading: refreshSignAppealButton)
            }
            .tabItem { Image(systemName: "arrow.up.doc.on.clipboard") }.tag(1)

            NavigationView {
                List(viewModel.macModifyList, id: \.id) { (each) in
                    MACModificationRow(modification: each)
                        .padding(6)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("MAC 修改申请"), displayMode: .large)
                .navigationBarItems(leading: refreshMACButton, trailing: exitButton)
            }
            .tabItem { Image(systemName: "command.square") }.tag(2)
        }
    }
    
    var refreshSignAppealButton: some View {
        Button(action: self.viewModel.refreshRemoteSignAppealList) {
            Text("刷新")
        }
    }
    
    var refreshSignListButton: some View {
        Button(action: self.viewModel.refreshRemoteMacModifyList) {
            Text("刷新")
        }
    }
    
    var refreshMACButton: some View {
        Button(action: self.viewModel.refreshRemoteSignAppealList) {
            Text("刷新")
        }
    }
    
    var exitButton: some View {
        Button(action: {self.viewRouter.isLogined.toggle()}) {
            Text("退出登录")
        }
    }
}

struct SignListRowView: View {
    @State var sign: SignListResponseData
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(sign.courseName)
                    .font(.headline)
                Text((sign.studentName ?? "") + " " + (sign.mac ?? "None MAC"))
                    .font(.subheadline)
                Text(sign.datetime)
                    .font(.caption)
            }
            Spacer()
            Image(systemName: (sign.status ? "checkmark.seal.fill" : "xmark.seal"))
                .foregroundColor(sign.status ? Color.blue : Color.pink.opacity(0.8))
        }
    }
}


struct SignAppealRowView: View {
    @State var sign: AdminSignAppealListResponseData
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(sign.courseName)
                    .font(.headline)
                Text((sign.studentName ?? "") + " " + (sign.mac ?? "None MAC"))
                    .font(.subheadline)
                Text(sign.datetime)
                    .font(.caption)
            }
            Spacer()
            Text(sign.status ? "已审核" : "待审核")
                .foregroundColor(sign.status ? Color.blue : Color.gray.opacity(0.8))
        }
    }
}


struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView(viewModel: AdminViewModel())
            .environmentObject(ViewRouter())
    }
}
