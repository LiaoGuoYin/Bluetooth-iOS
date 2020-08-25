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
    @State var form: Course
    @State var studentList: Array<Student>
    
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
                        ForEach(studentList, id: \.self) { (item: Student) in
                            HStack {
                                Text(item.name)
                                    .frame(width: 80)
                                Spacer()
                                Text(item.classOf)
                                Spacer()
                                Text(item.mac)
                            }
                        }
                        .onMove(perform: onMoveStudent)
                        .onDelete(perform: onDeleteStudent)
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
                leading: EditButton(),
                trailing: Button(action: {
                self.submitForm()
            }) { Text("Done")})
        }
    }
}

extension NewCourseFormView {
    init(viewModel: TeacherCourseViewModel) {
        self.init(viewModel: viewModel, form: Course(), studentList: studentsDemo)
    }
    
    func onMoveStudent(source: IndexSet, destination: Int) {
        studentList.move(fromOffsets: source, toOffset: destination)
    }
    
    func onDeleteStudent(at indexSet: IndexSet) {
        studentList.remove(atOffsets: indexSet)
    }
    
    func clearForm() {
        studentList = []
        form.clear()
    }
    
    func submitForm() {
        self.form.students = studentList
        self.viewModel.courseList.append(self.form)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct NewCourseFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewCourseFormView(viewModel: TeacherCourseViewModel())
    }
}
