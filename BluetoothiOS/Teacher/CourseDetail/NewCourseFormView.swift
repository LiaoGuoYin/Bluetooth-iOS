////
////  NewCourseFormView.swift
////  BluetoothPunchCard
////
////  Created by LiaoGuoYin on 2020/6/28.
////  Copyright © 2020 LiaoGuoYin. All rights reserved.
////
//
//import SwiftUI
//
//struct NewCourseFormView: View {
//    @ObservedObject var viewModel: TeacherCourseViewModel
//    @Environment(\.presentationMode) var presentationMode
////    @State var form: Course
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("基本信息")) {
//                    HStack {
//                        Text("课程名：")
//                            .foregroundColor(.gray)
//                        TextField("编译原理", text: self.$form.name)
//                            .font(.body)
//                    }
//                    HStack {
//                        Text("    班级：")
//                            .foregroundColor(.gray)
//                        TextField("信管17-2", text: self.$form.classOf)
//                            .font(.body)
//                    }
//                }
//
//                Section(header:HStack {
//                            Text("学生列表")
//                            Spacer()
//                            EditButton().foregroundColor(.blue)},
//                        footer:
//                            Text("Add TODO")) {
//                    List {
//                        ForEach(self.viewModel.studentsList, id: \.id) { (student: Student) in
//                            HStack {
//                                Text(student.name)
//                                Spacer()
//                                Text("\(student.id)")
//                            }
//                        }
//                        .onMove(perform: onMoveStudent)
//                        .onDelete(perform: onDeleteStudent)
//                    }
//                }
//
//                Button(action: { self.clearForm(self.$form) }) {
//                    HStack {
//                        Spacer()
//                        Text("重置")
//                            .foregroundColor(Color(.systemRed))
//                        Spacer()
//                    }
//                }
//
//                Button(action: { self.submitForm(self.form) }) {
//                    HStack {
//                        Spacer()
//                        Text("提交")
//                        Spacer()
//                    }
//                }
//            }
//            .disableAutocorrection(true)
//            .listStyle(GroupedListStyle())
//            .navigationBarTitle(Text("新增课程"), displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                self.submitForm(self.form)
//            }) { Text("Done")})
//        }
//    }
//}
//
//extension NewCourseFormView {
//    func onMoveStudent(source: IndexSet, destination: Int) {
//        self.viewModel.moveStudent(from: source, to: destination)
//    }
//
//    func onDeleteStudent(offsets: IndexSet) {
//        if let first = offsets.first {
//            self.viewModel.deleteStudent(first)
//        }
//    }
//
//    func clearForm(_ form: Binding<TeacherCourse.Course>) -> Void {
//        form.wrappedValue.name = ""
//        form.wrappedValue.classes = ""
//    }
//
//    func submitForm(_ form: TeacherCourse.Course) -> Void {
//        self.$viewModel.addCourse(self.form)
//        self.presentationMode.wrappedValue.dismiss()
//    }
//}
//
//struct NewCourseFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewCourseFormView(viewModel: TeacherCourseViewModel(), form: Course())
//    }
//}
