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
    @State var form: Course = Course(students: studentsDemo)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("课程名：")
                            .foregroundColor(.gray)
                        TextField("Python 程序设计", text: $form.name)
                            .font(.body)
                    }
                    HStack {
                        Text("    班级：")
                            .foregroundColor(.gray)
                        TextField("测试17-2", text: $form.classOf)
                            .font(.body)
                    }
                }
                
                Section(header: Text("学生列表")) {
                    List {
                        ForEach(form.students, id: \.self) { (item: Student) in
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
        form.clear()
    }
    
    func dismissForm() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func submitForm() {
        self.viewModel.courseList.append(form)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct NewCourseFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewCourseFormView(viewModel: TeacherCourseViewModel())
    }
}
