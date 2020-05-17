//
//  RegisterView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @Binding var isShow: Bool
    @State private var userNumber: String = ""
    @State private var userPass: String = ""
    @State private var userPassConfirm: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                CustomTextFieldView(varValue: self.userNumber, varName: "学号")
                
                CustomTextFieldView(varValue: self.userPass, varName: "密码")
                
                CustomTextFieldView(varValue: self.userPassConfirm, varName: "确认密码")
            }
            .navigationBarTitle(Text("注册"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.isShow = false
                }) {
                    Text("Done").bold()
                }
            )
        }
    }
}

//struct RegisterView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        RegisterView()
//    }
//}
