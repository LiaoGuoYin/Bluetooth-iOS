//
//  LoginView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "person").foregroundColor(.gray)
                    TextField("1710030215", text: self.$username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                HStack {
                    Image(systemName: "staroflife.fill").foregroundColor(.gray)
                    SecureField("********", text: self.$password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                
                HStack {
                    Spacer()
                    Button(action: { }) {
                        Text("忘记密码?").font(.caption)
                            .padding(.vertical)
                    }
                    .navigationBarItems(
                        leading: NavigationLink(destination: RegisterView(), label: {
                            Text("注册")
                                .padding(.vertical)
                        })
                        , trailing: Button(action: { self.postLogin() }) {
                            Text("登陆")
                                .padding(.vertical)
                        }
                    )
                        .navigationBarTitle(Text("LogIn"), displayMode: .inline)
                }
                .padding()
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                    UITableViewCell.appearance().backgroundColor = .white
                    UITableView.appearance().backgroundColor = .white
                }
                .onDisappear {
                    UITableView.appearance().separatorStyle = .singleLine
                }
                Spacer()
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension LoginView {
    func postRegister() {
        
    }
    
    func postLogin() {
        
    }
    
    func postForget() {
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

public struct ListSeparatorStyleNoneModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().separatorStyle = .none
        }
        .onDisappear {
            UITableView.appearance().separatorStyle = .singleLine
        }
    }
}

extension View {
    public func listSeparatorStyleNone() -> some View {
        modifier(ListSeparatorStyleNoneModifier())
    }
}
