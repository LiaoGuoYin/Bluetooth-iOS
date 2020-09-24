//
//  StudentModifyMacView.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/24.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentModifyMacView: View {
    
    @State var loginViewModel: LoginViewModel
    @State private var isShowAlert: Bool = false
    @State private var message = ""
    @State private var newMac = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("原 MAC: \(loginViewModel.responseData?.mac  ?? "None")"), content: {
                    HStack {
                        Text("NEW MAC: ")
                        TextField(loginViewModel.responseData?.mac ?? "4C:1A:3D:49:3E:6C", text: $newMac)
                    }
                })
                Button(action: submitModifyRequest) {
                    HStack {
                        Spacer()
                        Text("提交")
                        Spacer()
                    }
                }
            }
        }
        .alert(isPresented: $isShowAlert, content: {
            Alert.init(title: Text(message))
        })
    }
}

struct StudentModifyMacView_Previews: PreviewProvider {
    static var previews: some View {
        StudentModifyMacView(loginViewModel: LoginViewModel(form: LoginUser(username: "1001", password: "")))
    }
}

extension StudentModifyMacView {
    func submitModifyRequest() {
        APIClient.studentModifyMac(username: loginViewModel.form.username, newMac: newMac) { (result) in
            switch result {
            case .failure(let error):
                message = error.localizedDescription
                print(error)
                self.isShowAlert.toggle()
            case .success(let response):
                message = response.msg
                print(response.msg)
                self.isShowAlert.toggle()
            }
        }
    }
}
