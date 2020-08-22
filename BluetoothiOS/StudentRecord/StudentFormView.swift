////
////  StudentFormView.swift
////  BluetoothPunchCard
////
////  Created by LiaoGuoYin on 2020/4/7.
////  Copyright © 2020 LiaoGuoYin. All rights reserved.
////
//
//import SwiftUI
//
//struct StudentFormView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @ObservedObject var viewModel: TeacherCourseViewModel = TeacherCourseViewModel()
//
//    var body: some View {
//        Form {
//            Section(header: Text("基本信息")) {
//                HStack {
//                    Text("姓名：")
//                    TextField("张三", text: $viewModel.form.name)
//                }
//                //                HStack {
//                //                    Text("学号：")
//                //                    TextField("1710030215", text: Binding<Int>($viewModel.form.id))
//                //                        .keyboardType(.numberPad)
//                //                }
//                //                HStack {
//                //                    Text("院系：")
//                //                    TextField("工商管理学院", text: $form.depar)
//                //                }
//                HStack {
//                    Text("班级：")
//                    TextField("信管17-2", text: $viewModel.form.classOf)
//                }
//            }
//
//            Section(header: Text("设备信息")) {
//                HStack {
//                    Text("MAC地址：")
//                    TextField("a29s:23cs", text: $viewModel.form.mac)
//                }
//            }
//
//            Button(action: {
//                print(self.viewModel.form)
//                self.presentationMode.wrappedValue.dismiss()
//            }) {
//                HStack {
//                    Spacer()
//                    Text("提交")
//                    Spacer()
//                }
//            }
//        }
//        .disableAutocorrection(true)
//        .listStyle(GroupedListStyle())
//    }
//
//    var backButton: some View {
//        Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }, label: {
//            HStack {
//                Image(systemName: "chevron.left")
//                    .opacity(self.presentationMode.wrappedValue.isPresented ? 1 : 0)
//            }
//        })
//    }
//}
//
//struct ClassListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseFormView(viewModel: TeacherTeacherCourseViewModel(), form: TeacherCourse.Course(name: "", classes: ""))
//    }
//}
