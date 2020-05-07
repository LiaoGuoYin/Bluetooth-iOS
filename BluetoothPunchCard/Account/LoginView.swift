//
//  LoginView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/5/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var username: String
    @State var password: String
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Form {
                    Section(
                        footer: HStack {
                            Spacer()
                            Button(action: { self.postForget() }) {
                                Text("忘记密码?")
                                    .padding(.vertical)
                            }
                    }) {
                        HStack {
                            Text("账号:\t")
                            TextField("1710030215", text: self.$username)
                        }
                        HStack {
                            Text("密码:\t")
                            TextField("******", text: self.$password)
                        }
                    }
                }
                .navigationBarItems(
                    leading: Button(action: { self.postRegist() }) {
                        Text("注册")
                            .padding(.vertical)
                    },
                    trailing: Button(action: { self.postLogin() }) {
                        Text("登陆")
                            .padding(.vertical)
                    }
                )
                    .navigationBarTitle(Text(""), displayMode: .inline)
                
            }
        }
    }
}

extension LoginView {
    func postRegist() {
        
    }
    
    func postLogin() {
        
    }
    
    func postForget() {
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(username: "", password: "")
    }
}
