//
//  TeacherRegistering.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/13.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TeacherRegistering: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: TechearFormViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("工号：")
                        TextField("2141", text: self.$viewModel.form.id)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("姓名：")
                        TextField("张三", text: $viewModel.form.name)
                    }
                    HStack {
                        Text("手机：")
                        TextField("17671615140", text: self.$viewModel.form.phone)
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
            .navigationBarTitle("REGISTER", displayMode: .inline)
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

struct TeacherRegistering_Previews: PreviewProvider {
    static var previews: some View {
        TeacherRegistering(viewModel: TechearFormViewModel(form: TeacherForm()))
    }
}

extension TeacherRegistering {
    func clearForm() {
        self.viewModel.clear()
    }
    
    func submitForm() {
        
    }
}
