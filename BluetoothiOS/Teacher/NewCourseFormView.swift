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
    @State var form: Course = courseDemo
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("课程名：")
                            .foregroundColor(.gray)
                        TextField("测试课程", text: $form.name)
                            .font(.body)
                    }
                    HStack {
                        Text("    班级：")
                            .foregroundColor(.gray)
                        TextField("测试17-2", text: $form.classOf)
                            .font(.body)
                    }
                }
                
                Section(header:HStack {
                            Text("学生列表")
                            Spacer()
                            EditButton().foregroundColor(.blue)},
                        footer:
                            Text("Add TODO")) {
                    List {
                        ForEach(form.students, id: \.id) { (item: Student) in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.mac)
                            }
                        }
                        //.onMove(perform: onMoveStudent)
                        //.onDelete(perform: onDeleteStudent)
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
            .navigationBarItems(trailing: Button(action: {
                self.submitForm()
            }) { Text("Done")})
        }
    }
}

extension NewCourseFormView {
    //        func onMoveStudent(source: IndexSet, destination: Int) {
    //            self.viewModel.moveStudent(from: source, to: destination)
    //        }
    //
    //        func onDeleteStudent(offsets: IndexSet) {
    //            if let first = offsets.first {
    //                self.viewModel.deleteStudent(first)
    //            }
    //        }
    
    func clearForm() {
        form.clear()
    }
    
    func submitForm() {
        self.viewModel.addCourse(self.form)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct NewCourseFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewCourseFormView(viewModel: TeacherCourseViewModel(), form: Course())
    }
}
