//
//  LoginView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/5/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel: LoginViewModel
    @State private var isShowPassword: Bool = false
    @State private var isShowAlert: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: forgetPasswordButton) {
                    HStack {
                        Text("账号:\t")
                        TextField("1001", text: $viewModel.form.username)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("密码:\t")
                        if isShowPassword {
                            TextField("请输入密码", text: $viewModel.form.password)
                                .autocapitalization(.none)
                        } else {
                            SecureField("请输入密码", text: $viewModel.form.password)
                        }
                        Spacer()
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
                leading: NavigationLink(
                    destination: RegistView(viewModel: RegistViewModel(StudentForm()))
                    ,label: { Text("注册") }),
                trailing: Button(action: { self.postLogin() }) {
                    Text("登录")
                        .padding(.vertical)
                }
            )
            .navigationBarTitle(Text("LOGIN"), displayMode: .inline)
        }
        .alert(isPresented: self.$isShowAlert) {
            Alert.init(title: Text(String(viewModel.message)), message: nil, dismissButton: .default(Text("OK")))
        }
        .onAppear(perform: {
            loadLocalAccount()
        })
    }
    
    var forgetPasswordButton: some View {
        HStack {
            Spacer()
            Button(action: { self.isShowAlert.toggle() }) {
                Text("忘记密码?")
                    .padding(.vertical)
            }
        }
    }
}

extension LoginView {
    
    func loadLocalAccount() {
        if let accountDict = UserDefaults.standard.dictionary(forKey: "account") as? [String: String] {
            self.viewModel.form.username = accountDict["username"] ?? ""
            self.viewModel.form.password = accountDict["password"] ?? ""
        }
    }
    
    func postLogin() {
        self.viewModel.login { (isValid) in
            self.isShowAlert = true
            if isValid {
                self.viewRouter.isLogined = true
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(form: LoginUser(username: "", password: " "))).environmentObject(ViewRouter())
    }
}

