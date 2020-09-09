//
//  StudentFormView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentFormView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: StudentFormViewModel
    
    var body: some View {
        NavigationView {
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
                
                Button(action: {
                    print(self.viewModel.form)
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

struct StudentFormView_Previews: PreviewProvider {
    static var previews: some View {
        StudentFormView(viewModel: StudentFormViewModel(studentForm: StudentForm()))
    }
}
