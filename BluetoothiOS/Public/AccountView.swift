//
//  AccountView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/5.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct AccountView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State var loginViewModel: LoginViewModel?
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("个人信息")) {
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(loginViewModel?.responseData?.name ?? "未登录姓名")
                                        .font(.headline)
                                    Text(loginViewModel?.responseData?.mac ?? "未登录 mac")
                                        .font(.subheadline)
                                    (Text("学号: ") + Text(loginViewModel?.responseData?.number ?? "未登录学号"))
                                        .font(.subheadline)
                                    
                                }
                                Spacer()
                                Image(uiImage:generateQRCodeImage(qrString: loginViewModel?.responseData?.mac ?? "未登录 mac"))
                                    .resizable()
                                    .frame(width: 64,height: 64,alignment: .center)
                                    .padding()
                            }
                        })
                }
                .padding(8)
                
                Section(header: Text("签到记录")) {
                    HStack {
                        ImageAndTextView(imageName: "xmark.seal.fill", textName: "无效签到次数", imageColor: .red)
                        Spacer()
                        Text("1 次")
                    }
                    
                    HStack {
                        ImageAndTextView(imageName: "checkmark.seal.fill", textName: "有效签到次数", imageColor: .green)
                        Spacer()
                        Text("5 次")
                    }
                    
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            ImageAndTextView(imageName: "command", textName: "签到申诉记录",imageColor: .gray)
                        })
                    
                    NavigationLink(
                        destination: StudentRecordHistoryView(signList: [SignListResponseData(id: "29930", tNumber: "94", courseName: "Swift", sName: "Swift New", iClass: nil, sNumber: "1001", sMAC: "12:34:sd:sf:s2:cj", status: "0", date: "", datetime: 1585792859305)]),
                        label: {
                            ImageAndTextView(imageName: "seal.fill", textName: "所有签到", imageColor: .purple)
                        })
                }
                .padding(8)
                
                Button(action: {self.exitLogin()}) {
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
        AccountView()
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

extension AccountView {
    func generateQRCodeImage(qrString: String) -> UIImage {
        let data = Data(qrString.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
    
    func exitLogin() {
        self.viewRouter.isLogined = false
    }
}
