//
//  AccountView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/5.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationView {
            List {
                
                Section(header: Text("个人信息")) {
                    HStack {
                        Image(systemName: "t.bubble")
                            .resizable()
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("廖国胤")
                            Text("学号：1710030215")
                        }
                        .padding()
                    }
                }
                .padding(8)
                
                Section(header: Text("签到记录")) {
                    HStack {
                        ImageAndTextView(imageName: "checkmark.seal.fill", textName: "有效次数")
                            .foregroundColor(Color.red)
                        Spacer()
                        Text("5 次")
                    }
                    HStack {
                        ImageAndTextView(imageName: "xmark.seal.fill", textName: "无效次数")
                            .foregroundColor(Color.green)
                        Spacer()
                        Text("1 次")
                    }
                }
                .padding(8)
                
                Section(header: Text("其他功能")) {
                    ImageAndTextView(imageName: "rectangle.stack.badge.person.crop", textName: "信息修改")
                    //            ImageAndTextView(imageName: "rectangle.stack.person.crop.fill", textName: "有效无效次数")
                    //            ImageAndTextView(imageName: "rectangle.stack.person.crop.fill", textName: "无效签到次数")
                    ImageAndTextView(imageName: "command", textName: "签到申诉记录")
                    ImageAndTextView(imageName: "number.square", textName: "MAC地址修改申请")
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
    @State var imageName: String
    @State var textName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(textName)
        }
    }
}
