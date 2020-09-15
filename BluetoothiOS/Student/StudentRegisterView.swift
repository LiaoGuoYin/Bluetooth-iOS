//
//  StudentRegisterView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentRegisterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: StudentRegisterViewModel
    
    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                HStack {
                    Text("姓名：")
                    TextField("张三", text: $viewModel.form.name)
                }
                HStack {
                    Text("学号：")
                    TextField("1710030215", text: self.$viewModel.form.id)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Picker("学院：", selection: self.$viewModel.form.college) {
                        ForEach(College.allCases) { college in
                            Text(college.rawValue.capitalized).tag(college)
                        }
                    }
                }
                HStack {
                    Text("班级：")
                    TextField("电信研183", text: self.$viewModel.form.iClass)
                }
            }
            
            Section(header: Text("其他信息")) {
                HStack {
                    Text("密码：")
                    SecureField("********", text: self.$viewModel.form.password)
                }
                HStack {
                    Text("确认密码：")
                    SecureField("********", text: self.$viewModel.form.rePassword)
                }
                HStack {
                    Text("MAC地址：")
                    TextField("A29S:23CS", text: $viewModel.form.mac)
                }
            }
            
            Button(action: { self.clearForm() }) {
                HStack {
                    Spacer()
                    Text("重置")
                        .foregroundColor(Color(.systemRed))
                    Spacer()
                }
            }
            
            Button(action: {
                self.submitForm()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("提交")
                    Spacer()
                }
            }
            .disableAutocorrection(true)
            .listStyle(GroupedListStyle())
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.left")
                    .opacity(self.presentationMode.wrappedValue.isPresented ? 1 : 0)
            }
        })
    }
}

extension StudentRegisterView {
    func clearForm() {
        self.viewModel.clear()
    }
    
    func submitForm() {
        
    }
}

struct StudentRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRegisterView(viewModel: StudentRegisterViewModel(studentForm: StudentForm()))
    }
}
