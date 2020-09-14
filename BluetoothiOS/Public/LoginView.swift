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
    @State var userType: UserType = .teacher
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
                        TextField("1710030215", text: self.$username)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("密码:\t")
                        
                        if isShowPassword {
                            TextField("请输入密码", text: $password, onCommit: {
                                
                            })
                            .autocapitalization(.none)
                        } else {
                            SecureField("请输入密码", text: $password, onCommit: {
                                
                            })
                        }
                        
                        Button(action: {self.isShowPassword.toggle()}) {
                            Image(systemName: isShowPassword ? "lock.open.fill": "lock")
                        }
                    }
                    Picker(selection: $userType, label: Text("用户类型：")) {
                        ForEach(UserType.allCases) { user in
                            Text(user.rawValue.capitalized).tag(user)
                        }
                    }
                    
                }
            }
            .navigationBarItems(
                leading: Button(action: { self.showRegistering() }) {
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
            if self.userType == .student {
                StudentFormView(viewModel: StudentFormViewModel(studentForm: StudentForm()))
            } else {
                TeacherRegisteringView(viewModel: TechearFormViewModel(form: TeacherForm()))
            }
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
            self.username = accountDict["username"] ?? ""
            self.password = accountDict["password"] ?? ""
        }
    }
    
    func showRegistering() {
        self.isShowRegisteringForm.toggle()
    }
    
    func postLogin() {
        if self.checkAccount() {
            self.viewRouter.isLogined = true
            UserDefaults.standard.setValue(
                [
                    "username": self.username,
                    "password": self.password,
                ], forKey: "account")
        } else {
            self.isShowForgetPassword = true
        }
    }
    
    func checkAccount() -> Bool{
        if self.username == "1001" && password == "admin"{
            return true
        } else {
            return false
        }
    }
    
    func postForget() {
        self.isShowForgetPassword.toggle()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ViewRouter())
    }
}

enum UserType: String, Identifiable, CaseIterable {
    case student = "学生"
    case teacher = "教师"
    case admin = "管理员"
    var id: String { self.rawValue }
}
