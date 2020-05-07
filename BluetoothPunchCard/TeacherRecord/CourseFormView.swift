//
//  CourseFormView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct CourseFormView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var iClass: String = ""
    @State var studentList: [String] = []

    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                HStack {
                    Text("姓名：")
                    TextField("张三", text: self.$iClass)
                }
                HStack {
                    Text("手机：")
                    TextField("13888888888", text: self.$iClass)
                }
                HStack {
                    Text("院系：")
                    TextField("工商管理学院", text: self.$iClass)
                }
                HStack {
                    Text("班级：")
                    TextField("信管17-2", text: self.$iClass)
                }
            }

            Section(header: Text("设备信息")) {
                HStack {
                    Text("MAC地址：")
                    TextField("a29s:23cs", text: self.$iClass)
                }
            }

            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("提交")
                    Spacer()
                }
            }
        }
        .listStyle(GroupedListStyle())
    }

    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.left")
                    .opacity(self.presentationMode.wrappedValue.isPresented ? 1 : 0)
            }
        })
    }
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        CourseFormView()
    }
}
