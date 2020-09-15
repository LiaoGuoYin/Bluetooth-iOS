//
//  LoginView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/5/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var isShowPassword: Bool = false
    @State private var isShowForgetPassword: Bool = false
    @State private var isShowRegisteringForm: Bool = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer:
                            HStack {
                                Spacer()
                                Button(action: { self.postForget() }) {
                                    Text("忘记密码?")
                                        .padding(.vertical)
                                }
                            }) {
                    HStack {
                        Text("账号:\t")
                        TextField("1710030215", text: $viewModel.form.username)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("密码:\t")
                        
                        if isShowPassword {
                            TextField("请输入密码", text: $viewModel.form.passwd, onCommit: {
                                
                            })
                            .autocapitalization(.none)
                        } else {
                            SecureField("请输入密码", text: $viewModel.form.passwd, onCommit: {
                                
                            })
                        }
                        
                        Button(action: {self.isShowPassword.toggle()}) {
                            Image(systemName: isShowPassword ? "lock.open.fill": "lock")
                        }
                    }
                    Picker(selection: $viewModel.form.userType, label: Text("用户类型：")) {
                        ForEach(UserType.allCases) { user in
                            Text(user.rawValue.capitalized).tag(user)
                        }
                    }
                    
                }
            }
            .navigationBarItems(
                leading:
                    NavigationLink(
                        destination:
                            (StudentRegisterView(viewModel: StudentRegisterViewModel(studentForm: StudentForm())))
                        ,
                        label: {
                            Text("注册")
                        })
                ,
                trailing: Button(action: { self.postLogin() }) {
                    Text("登录")
                        .padding(.vertical)
                }
            )
            .navigationBarTitle(Text("LOGIN"), displayMode: .inline)
        }
        .alert(isPresented: self.$isShowForgetPassword) {
            //            Alert(title: Text("忘记密码别找我！"), message: Text("暂不支持在线找回"), dismissButton: .default(Text("OK")))
            Alert.init(title: Text("密码错误"), message: Text("用户名或密码错误"), dismissButton: .default(Text("确认")))
        }
        .onAppear(perform: {
            loadLocalAccount()
        })
    }
}

extension LoginView {
    
    func loadLocalAccount() {
        if let accountDict = UserDefaults.standard.dictionary(forKey: "account") as? [String: String] {
            self.viewModel.form.username = accountDict["username"] ?? ""
            self.viewModel.form.passwd = accountDict["password"] ?? ""
        }
    }
    
    func showRegistering() {
        self.isShowRegisteringForm.toggle()
    }
    
    func postLogin() {
        self.viewModel.checkAccount {result in
            self.viewRouter.isLogined = true
            UserDefaults.standard.setValue([
                "username": self.viewModel.form.username,
                "password": self.viewModel.form.passwd,
            ], forKey: "account")
            
            if result as! Bool == true {
                self.isShowForgetPassword = false
            }else {
                self.isShowForgetPassword = true
            }
        }
    }
    
    func postForget() {
        self.isShowForgetPassword.toggle()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(form: LoginUser(username: "", passwd: " "))).environmentObject(ViewRouter())
    }
}
