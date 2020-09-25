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
                    HistoryBlockRow(sign: record)
                        .padding(6)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("签到记录"), displayMode: .large)
                .navigationBarItems(leading: refreshSignButton)
            }
            .tabItem { Image(systemName: "square.and.at.rectangle") }.tag(1)
            
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
    
    var refreshSignButton: some View {
        Button(action: self.viewModel.refreshRemoteSignAppealList) {
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
            Text("退出")
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView(viewModel: AdminViewModel())
            .environmentObject(ViewRouter())
    }
}
