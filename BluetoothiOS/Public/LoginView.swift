//
//  LoginView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/5/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var user: UserType = .student
    @State private var isShowPassword: Bool = false
    @State private var isShowForgetPassword: Bool = false
    @State private var isShowRegisteringForm: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    footer:
                        HStack {
                            Spacer()
                            Button(action: { self.postForget() }) {
                                Text("忘记密码?")
                                    .padding(.vertical)
                            }
                            .alert(isPresented: self.$isShowForgetPassword) {
                                Alert(title: Text("忘记密码别找我！"), message: Text("找教务处"), dismissButton: .default(Text("OK")))
                            }
                        }) {
                    HStack {
                        Text("账号:\t")
                        TextField("1710030215", text: self.$username)
                    }
                    HStack {
                        Text("密码:\t")
                        //                        SecureField("********", text: self.$password)
                        
                        if isShowPassword {
                            TextField("请输入密码", text: $password, onCommit: {
                                
                            })
                        } else {
                            SecureField("请输入密码", text: $password, onCommit: {
                                
                            })
                        }
                        Button(action: {self.isShowPassword.toggle()}) {
                            Image(systemName: isShowPassword ? "lock.open.fill": "lock")
                        }
                    }
                    Picker(selection: $user, label: Text("用户类型：")) {
                        ForEach(UserType.allCases) { user in
                            Text(user.rawValue.capitalized).tag(user)
                        }
                    }
                }
            }
            .navigationBarItems(
                leading: Button(action: { self.postRegist() }) {
                    Text("注册")
                        .padding(.vertical)
                },
                trailing: Button(action: { self.postLogin() }) {
                    Text("登录")
                        .padding(.vertical)
                }
            )
            .navigationBarTitle(Text("LOGIN"), displayMode: .inline)
        }
        .sheet(isPresented: self.$isShowRegisteringForm) {
            StudentFormView(viewModel: StudentFormViewModel(studentForm: StudentForm()))
        }
    }
}

extension LoginView {
    func postRegist() {
        self.isShowRegisteringForm.toggle()
    }
    
    func postLogin() {
        
    }
    
    func postForget() {
        self.isShowForgetPassword.toggle()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

enum UserType: String, Identifiable, CaseIterable {
    case student = "学生"
    case teacher = "教师"
    case admin = "管理员"
    
    var id: String { self.rawValue }
}
