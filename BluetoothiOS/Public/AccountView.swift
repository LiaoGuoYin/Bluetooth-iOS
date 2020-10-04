//
//  AccountView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/5.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("个人信息")) {
                    NavigationLink(
                        destination: StudentModifyMacView(loginViewModel: loginViewModel),
                        label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(loginViewModel.responseData?.name ?? "未登录姓名")
                                        .font(.headline)
                                    Text(loginViewModel.responseData?.mac ?? "未登录 mac")
                                        .font(.subheadline)
                                    (Text("学号: ") + Text(loginViewModel.responseData?.number ?? "未登录学号"))
                                        .font(.subheadline)
                                }
                                Spacer()
                                Image(uiImage: QRGenerator().generateQRCodeImage(qrString: loginViewModel.responseData?.mac ?? "未登录 mac"))
                                    .resizable()
                                    .frame(width: 64,height: 64,alignment: .center)
                                    .padding()
                            }
                        })
                }
                .padding(8)
                
            Section(header: Text("考勤记录")) {
//                HStack {
//                    ImageAndTextView(imageName: "xmark.seal.fill", textName: "无效签到次数", imageColor: .red)
//                    Spacer()
//                    Text("1 次")
//                }
//                HStack {
//                    ImageAndTextView(imageName: "checkmark.seal.fill", textName: "有效签到次数", imageColor: .green)
//                    Spacer()
//                    Text("5 次")
//                }
                NavigationLink(
                    destination: StudentSignHistoryView(viewModel: StudentSignHistoryViewModel(studentNumber: loginViewModel.form.username)),
                    label: {
                        ImageAndTextView(imageName: "seal.fill", textName: "所有考勤", imageColor: .purple)
                    })
            }
                .padding(8)
                
                Button(action: {viewRouter.isLogined.toggle()}) {
                    ImageAndTextView(imageName: "rectangle.portrait.arrowtriangle.2.outward", textName: "退出登录", imageColor: .blue)
                        .padding(8)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("账户中心")
        }
    }
    
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(loginViewModel: LoginViewModel(form: LoginUser(username: "1001", password: "1001")))
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
