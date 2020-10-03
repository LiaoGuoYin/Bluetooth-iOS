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
        Form {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        Image(uiImage: QRGenerator().generateQRCodeImage(qrString: loginViewModel.responseData?.mac ?? "未登录"))
                            .resizable()
                            .frame(width: 81,height: 81,alignment: .center)
                            .padding()
                        Text("原 MAC 地址: \(loginViewModel.responseData?.mac  ?? "")")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                
                HStack {
                    Text("新 MAC 地址")
                    TextField(":::::", text: $newMac)
                }
            }
            Button(action: submitModifyRequest) {
                HStack {
                    Spacer()
                    Text("提交")
                    Spacer()
                }
            }
        }
        .navigationBarTitle(Text("申请修改MAC地址"), displayMode: .inline)
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
