//
//  StudentView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/5.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var BLEConnection = BLEManager.shared
    @State var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("账户中心")) {
                    NavigationLink(
                        destination: StudentModifyMacView(loginViewModel: loginViewModel),
                        label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(loginViewModel.responseData?.name ?? "未登录姓名")
                                        .font(.headline)
                                    Text(loginViewModel.responseData?.iClass ?? "未登录班级")
                                        .font(.subheadline)
                                    (Text("学号: ") + Text(loginViewModel.responseData?.number ?? "未登录学号"))
                                        .font(.subheadline)
                                    (Text("MAC: ") + Text(loginViewModel.responseData?.mac ?? "未登录 mac"))
                                        .font(.subheadline)
                                }
                                Spacer()
                                Image(uiImage: QRGenerator().generateQRCodeImage(qrString: loginViewModel.responseData?.mac ?? "未登录 mac"))
                                    .resizable()
                                    .frame(width: 64,height: 64,alignment: .center)
                                    .padding()
                            }
                        })
                    NavigationLink(
                        destination: StudentSignHistoryView(viewModel: StudentSignHistoryViewModel(studentNumber: loginViewModel.form.username)),
                        label: {
                            ImageAndTextView(imageName: "seal.fill", textName: "考勤记录", imageColor: .purple)
                        })
                }
                .padding(8)
                
                Section(header: Text("上课期间，请保持开启蓝牙以被扫描")) {
                    Toggle("开启蓝牙", isOn: self.$BLEConnection.isOn)
                }
                
                Button(action: {viewRouter.isLogined.toggle()}) {
                    ImageAndTextView(imageName: "rectangle.portrait.arrowtriangle.2.outward", textName: "退出登录", imageColor: .blue)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("学生，\(loginViewModel.form.username)")
        }
    }
    
}

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView(loginViewModel: LoginViewModel(form: LoginUser(username: "1001", password: "1001")))
    }
}

struct ImageAndTextView: View {
    var imageName: String
    var textName: String
    var imageColor: Color?
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(imageColor)
                .frame(width: 22)
            Text(textName)
        }
    }
}
