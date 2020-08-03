//
//  StudentFormView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentFormView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: CourseViewModel = CourseViewModel()

    @State var form = Student(userid: "1", name: "", iClass: "", mac: "")

    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                HStack {
                    Text("姓名：")
                    TextField("张三", text: $form.name)
                }
//                HStack {
//                    Text("手机：")
//                    TextField("13888888888", text: $form.userid)
//                }
                HStack {
                    Text("学号：")
                    TextField("1710030215", text: $form.userid)
                        .keyboardType(.numberPad)
                }
//                HStack {
//                    Text("院系：")
//                    TextField("工商管理学院", text: $form.depar)
//                }
                HStack {
                    Text("班级：")
                    TextField("信管17-2", text: $form.iClass)
                }
            }

            Section(header: Text("设备信息")) {
                HStack {
                    Text("MAC地址：")
                    TextField("a29s:23cs", text: $form.mac)
                }
            }

            Button(action: {
//                viewModel.addCourse(of: T##Course)
                print(self.form)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("提交")
                    Spacer()
                }
            }
        }
            .disableAutocorrection(true)
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
