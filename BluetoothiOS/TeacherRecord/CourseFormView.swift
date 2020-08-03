//
//  CourseFormView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct CourseFormView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    @Environment(\.presentationMode) var presentationMode
    //    @State var form: TeacherCourse.Course = TeacherCourse.Course(name: "", classes: "")
    @State var form: TeacherCourse.Course = courseDemo

    init() {
        UITableView.appearance().backgroundColor = .systemGroupedBackground
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("课程名：")
                            .foregroundColor(.gray)
                        TextField("编译原理", text: $form.name)
                            .font(.body)
                    }
                    HStack {
                        Text("    班级：")
                            .foregroundColor(.gray)
                        TextField("信管17-2", text: $form.classes)
                            .font(.body)
                    }
                }

                Section(
                    header: HStack {
                        Text("学生列表")
                        Spacer()
                        EditButton()
                    },
                    footer: Text("Add TODO")) {
                    List {
                        ForEach(form.students, id: \.userid) { (student: Student) in
                            HStack {
                                Text(student.name)
                                Spacer()
                                Text(student.userid)
                            }
                        }
                            .onMove(perform: onMove)
                            .onDelete(perform: onDelete)
                    }
                }

                Button(action: { self.clearForm(self.$form) }) {
                    HStack {
                        Spacer()
                        Text("重置")
                            .foregroundColor(Color(.systemRed))
                        Spacer()
                    }
                }

                Button(action: { self.submitForm(self.form) }) {
                    HStack {
                        Spacer()
                        Text("提交")
                        Spacer()
                    }
                }
            }
                .navigationBarTitle(Text("新增课程"), displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: { self.submitForm(self.form) }) {
                        Text("Done")
                })
                .disableAutocorrection(true)
                .listStyle(GroupedListStyle())
        }
    }

    private func onMove(source: IndexSet, destination: Int) {
        self.viewModel.move(from: source, to: destination)
    }

    private func onDelete(offsets: IndexSet) {
        if let first = offsets.first {
            self.viewModel.deleteCourse(first)
        }
    }

    func clearForm(_ form: Binding<TeacherCourse.Course>) -> Void {
        form.wrappedValue.name = "None"
        form.wrappedValue.classes = ""
    }

    func submitForm(_ form: TeacherCourse.Course) -> Void {
        self.viewModel.addCourse(form)
        //        self.$isShowSheet.wrappedValue.toggle()
        self.presentationMode.wrappedValue.dismiss()
    }
}

extension TeacherCourse.Course {
    mutating func clear() {
        self.name = ""
        self.classes = ""
        self.students = []
    }
}

struct NewCourseFormView_Previews: PreviewProvider {
    static var previews: some View {
        CourseFormView().environmentObject(CourseViewModel(courseDemo))
    }
}

struct addStudent: View {
    var body: some View {
        HStack {
            Image(systemName: "person.badge.plus.fill")
            Text("添加")
                .font(.caption)
        }
    }
}
