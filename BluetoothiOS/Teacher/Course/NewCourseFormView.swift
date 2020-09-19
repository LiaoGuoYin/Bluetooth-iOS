////
////  NewCourseFormView.swift
////  BluetoothPunchCard
////
////  Created by LiaoGuoYin on 2020/6/28.
////  Copyright © 2020 LiaoGuoYin. All rights reserved.
////

import SwiftUI

struct NewCourseFormView: View {
    
    @ObservedObject var viewModel: TeacherCourseViewModel
    @State private var isShowAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("课程名称：")
                            .foregroundColor(.gray)
                        TextField("程序设计基础", text: $viewModel.form.name)
                            .font(.body)
                    }
                    HStack {
                        Text("上课教室：")
                            .foregroundColor(.gray)
                        TextField("尔雅221", text: $viewModel.form.roomOf)
                            .font(.body)
                    }
                    HStack {
                        Text("教授班级：")
                            .foregroundColor(.gray)
                        TextField("测试研172", text: $viewModel.form.classOf)
                            .font(.body)
                    }
                }
                
                //                Section(header: studentListSectionHeader) {
                //                    List {
                //                        ForEach(viewModel.form.students, id: \.self) { (item: Student) in
                //                            HStack {
                //                                Text(item.name)
                //                                    .frame(width: 80)
                //                                Spacer()
                //                                Text(item.classOf)
                //                                Spacer()
                //                                Text(item.mac)
                //                            }
                //                        }
                //                    }
                //                }
                
                Button(action: clearForm) {
                    HStack {
                        Spacer()
                        Text("重置")
                            .foregroundColor(Color(.systemRed))
                        Spacer()
                    }
                }
                
                Button(action: submitForm) {
                    HStack {
                        Spacer()
                        Text("提交")
                        Spacer()
                    }
                }
            }
            .alert(isPresented: $isShowAlert, content: {
                Alert(title: Text(viewModel.message),
                      primaryButton: .destructive(Text("继续修改"), action: self.clearForm),
                      secondaryButton: .default(Text("完成"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                      })
            )})
            .disableAutocorrection(true)
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("新增课程"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: submitForm) { Text("提交")})
        }
    }
}

extension NewCourseFormView {
    
    var studentListSectionHeader: some View {
        HStack {
            Text("学生列表")
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Text("fresh")
                    .padding(6)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(5)
            }
        }
        .padding(3)
    }
    
    func clearForm() {
        self.viewModel.clearCourseForm()
    }
    
    func submitForm() {
        viewModel.createCourse()
        isShowAlert.toggle()
    }
}

struct NewCourseFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewCourseFormView(viewModel: TeacherCourseViewModel(teachNumber: "1001"))
    }
}
