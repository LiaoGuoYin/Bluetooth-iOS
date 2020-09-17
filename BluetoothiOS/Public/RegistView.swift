//
//  RegistView.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/16.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct RegistView: View {
    
    @ObservedObject var viewModel: RegistViewModel
    @State private var isShowAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                HStack {
                    Text(viewModel.userType == UserType.student ? "学号：": "工号：")
                    TextField("1001", text: $viewModel.form.number)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("姓名：")
                    TextField("两位汉字起", text: $viewModel.form.name)
                }
                HStack {
                    Text("手机：")
                    TextField("17671615141", text: $viewModel.form.phone)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("密码：")
                    SecureField("********", text: $viewModel.form.password)
                }
                HStack {
                    Text("确认密码：")
                    SecureField("********", text: $viewModel.form.password)
                }
            }
            
            if viewModel.userType == .student {
                Section(
                    header: Text("其他信息"),
                    footer: Text("蓝牙地址查看方式：设置 - 关于 - Bluetooth").padding(.vertical)
                ) {
                    //                    HStack {
                    //                        Picker("学院：", selection: self.$) {
                    //                            ForEach(College.allCases) { college in
                    //                                Text(college.rawValue.capitalized).tag(college)
                    //                            }
                    //                        }
                    //                    }
                    HStack {
                        Text("班级：")
                        TextField("信管研192", text: self.$viewModel.form.iClass)
                    }
                    HStack {
                        Text("MAC：")
                        TextField("BC:E1:43:B4:62:10", text: $viewModel.form.mac)
                    }
                }
            } else {
                EmptyView()
            }
            resetButton
            submitButton
        }
        .navigationBarItems(trailing: switchRegistUserTypeButton)
        .alert(isPresented: $isShowAlert, content: {
            Alert(title: Text(String(self.viewModel.message)), message: nil, dismissButton: .default(Text("OK")))
        })
        .disableAutocorrection(true)
        .listStyle(GroupedListStyle())
        .navigationBarTitle((viewModel.userType == UserType.student) ? "学生": "教师", displayMode: .inline)
    }
}

extension RegistView {
    var resetButton: some View {
        Button(action: {
            self.viewModel.clear()
        }) {
            HStack {
                Spacer()
                Text("重置")
                    .foregroundColor(Color(.systemRed))
                Spacer()
            }
        }
    }
    
    var submitButton: some View {
        Button(action: {
            viewModel.submitForm { _ in
                self.isShowAlert = true
            }
        }) {
            HStack {
                Spacer()
                Text("提交")
                Spacer()
            }
        }
    }
    
    var switchRegistUserTypeButton: some View {
        Button(action: {
                self.viewModel.userType =  viewModel.userType == UserType.student ? UserType.teacher: UserType.student }
        ) {
            Text(viewModel.userType == UserType.student ? "注册教师账户": "注册学生账户")
        }
    }
    
}

struct RegistView_Previews: PreviewProvider {
    static var previews: some View {
        RegistView(viewModel: RegistViewModel(StudentForm(), userType: .student))
    }
}
