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
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var macAddress: String = "F3K4:2JX0"
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("个人信息")) {
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("廖国胤")
                                        .font(.headline)
                                    Text(macAddress)
                                        .font(.subheadline)
                                    (Text("学号: ") + Text("1710030215"))
                                        .font(.subheadline)
                                    
                                }
                                Spacer()
                                Image(uiImage:generateQRCodeImage(qrString: macAddress))
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
                        destination: StudentRecordHistoryView(),
                        label: {
                            ImageAndTextView(imageName: "seal.fill", textName: "所有签到", imageColor: .purple)
                        })
                }
                .padding(8)
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
                .frame(width: 16)
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
}
