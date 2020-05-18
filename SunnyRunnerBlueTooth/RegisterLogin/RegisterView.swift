//
//  RegisterView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var userPassConfirm: String = ""
    @State private var birthDay: Date = Date()
    
    let fromToday = Calendar.current.date(byAdding: .minute, value: -1, to: Date())!
    
    var body: some View {
        Form {
            Section(header: Text("Account Info")) {
                HStack {
                    Text("学号\t\t")
                    TextField("1710030215", text: self.$username)
                }
                HStack {
                    Text("密码\t\t")
                    TextField("********", text: self.$password)
                }
                HStack {
                    Text("确认密码\t")
                    TextField("********", text: self.$password)
                }
            }
            
            Section(header: Text("Personal Info")) {
                //                DatePicker(selection: .constant(Date()), label: { Text("出生日期") })
                HStack {
                    Text("手机号\t\t")
                    TextField("13888888888", text: self.$username)
                }
                DatePicker("出生日期\t\t", selection: self.$birthDay, displayedComponents: .date)
                
            }
        }
        .navigationBarTitle(Text("注册"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: { }) {
                Text("Done")
                    .padding(.vertical)
            }
        )
            .onAppear {
                UITableView.appearance().separatorStyle = .singleLine
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
