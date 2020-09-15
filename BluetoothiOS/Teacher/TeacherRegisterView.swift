//
//  TeacherRegisterView.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/13.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TeacherRegisterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: TechearRegisterViewModel
    
    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                HStack {
                    Text("工号：")
                    TextField("1001", text: self.$viewModel.form.id)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("姓名：")
                    TextField("张三", text: $viewModel.form.name)
                }
                HStack {
                    Text("手机：")
                    TextField("17671615140", text: self.$viewModel.form.phone)
                        .keyboardType(.numberPad)
                }
            }
            
            Section(header: Text("其他信息")) {
                HStack {
                    Text("密码：\t")
                    SecureField("********", text: self.$viewModel.form.password)
                }
                HStack {
                    Text("确认密码：")
                    SecureField("********", text: self.$viewModel.form.rePassword)
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
        }
        .disableAutocorrection(true)
        .listStyle(GroupedListStyle())
        .navigationBarTitle("", displayMode: .inline)
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

struct TeacherRegistering_Previews: PreviewProvider {
    static var previews: some View {
        TeacherRegisterView(viewModel: TechearRegisterViewModel(form: TeacherForm()))
    }
}

extension TeacherRegisterView {
    func clearForm() {
        self.viewModel.clear()
    }
    
    func submitForm() {
        if checkForm() == "true" {
            //            MARK: - Reqeust
        } else {
            //            false
        }
        //        self.viewModel.submitForRequest(teacherForm: TeacherForm())
    }
    
    func checkForm() -> String {
        if self.viewModel.form.password != self.viewModel.form.rePassword {
            return "密码不一致"
        }
        
        if self.viewModel.form.id.count > 5 {
            return "工号长度不正确"
        }
        
        if self.viewModel.form.phone.count != 11 {
            return "手机长度不正确"
        }
        
        return "true"
    }
}
