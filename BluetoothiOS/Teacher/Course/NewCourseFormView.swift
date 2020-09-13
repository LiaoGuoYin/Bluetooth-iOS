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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("课程名称：")
                            .foregroundColor(.gray)
                        TextField("Python 程序设计", text: $viewModel.form.name)
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
                        TextField("测试17-2", text: $viewModel.form.classOf)
                            .font(.body)
                    }
                }
                
                Section(header: Text("学生列表")) {
                    List {
                        ForEach(viewModel.form.students, id: \.self) { (item: Student) in
                            HStack {
                                Text(item.name)
                                    .frame(width: 80)
                                Spacer()
                                Text(item.classOf)
                                Spacer()
                                Text(item.mac)
                            }
                        }
                    }
                }
                
                Button(action: { self.clearForm() }) {
                    HStack {
                        Spacer()
                        Text("重置")
                            .foregroundColor(Color(.systemRed))
                        Spacer()
                    }
                }
                
                Button(action: { self.submitForm() }) {
                    HStack {
                        Spacer()
                        Text("提交")
                        Spacer()
                    }
                }
            }
            .disableAutocorrection(true)
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("新增课程"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: { self.dismissForm() }) {Text("Cancel").foregroundColor(.red)},
                trailing: Button(action: { self.submitForm() }) { Text("Done")})
        }
    }
}

extension NewCourseFormView {
    func clearForm() {
        self.viewModel.clearCourseForm()
    }
    
    func dismissForm() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func submitForm() {
        self.viewModel.courseList.append(self.viewModel.form)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct NewCourseFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewCourseFormView(viewModel: TeacherCourseViewModel())
    }
}
