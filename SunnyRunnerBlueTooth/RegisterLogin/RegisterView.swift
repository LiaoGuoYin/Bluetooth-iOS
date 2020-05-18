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
                    Image(systemName: "person").foregroundColor(.gray)
                    TextField("Enter your student ID", text: self.$username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                HStack {
                    Image(systemName: "staroflife").foregroundColor(.gray)
                    SecureField("Password", text: self.$password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                HStack {
                    Image(systemName: "staroflife.fill").foregroundColor(.gray)
                    SecureField("Confirm Password", text: self.$password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            }
            
            Section(header: Text("Personal Info")) {
                //                DatePicker(selection: .constant(Date()), label: { Text("出生日期") })
                DatePicker("出生日期", selection: self.$birthDay, displayedComponents: .date)
                TextField("手机号", text: self.$username)
            }
        }
        .navigationBarTitle(Text("注册"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: { }) {
                Text("Done")
                    .padding(.vertical)
            }
        )
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
