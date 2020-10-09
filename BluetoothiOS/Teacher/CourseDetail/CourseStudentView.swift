//
//  CourseStudentView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct CourseStudentView: View {
    typealias Student = LoginResponseData
    
    @State var viewModel: TeacherCourseViewModel
    @State var courseInfo: CourseResponseData
    @State var studentSet: Set<Student> = Set()
    @State private var isShowingSheet: Bool = false
    @State private var isShowNewPage: Bool = false
    
    var body: some View {
        List {
            Section(header: Text("共计学生: \(studentSet.count)")) {
                ForEach(Array<Student>(studentSet), id: \.id) { student in
                    HStack(spacing: 16) {
                        Text(student.name)
                            .font(.headline)
                            .frame(width: 150)
                            .lineLimit(1)
                        VStack(alignment:.leading, spacing: 8) {
                            Text(student.mac ?? "Unknow")
                                .font(.caption)
                            Text(student.iClass ?? "Unknow")
                                .font(.caption)
                        }
                    }
                    .padding()
                    .onTapGesture(count: 2, perform: {
                        self.isShowingSheet.toggle()
                    })
                }
                .onDelete(perform: onDeleteStudent)
            }
        }
        .listStyle(GroupedListStyle())
        .sheet(isPresented: $isShowNewPage, content: {
            BLEView(studentList: Array<Student>(studentSet), courseName: viewModel.form.name, teacherNumber: viewModel.teacherNumber)
        })
        .actionSheet(isPresented: $isShowingSheet, content: {
            ActionSheet(title: Text("是否开始考勤？"),
                        message: Text("当前班级学生：\(studentSet.count) 人"),
                        buttons: [.default(Text("开始"), action: {
                            self.isShowNewPage.toggle()
                        }), .cancel(Text("取消"))])
        })
        .onAppear(perform: {
            for each in courseInfo.classList {
                viewModel.loadClassStudentList(className: each) { (tmpStudentList) in
                    for student in tmpStudentList {
                        studentSet.update(with: student)
                    }
                }
            }
        })
        .navigationBarTitle(Text("学生名单"))
        .navigationBarItems(trailing: sendSheetToBLEButton)
    }
}

extension CourseStudentView {
    private func onDeleteStudent(at indexSet: IndexSet) {
        viewModel.studentList.remove(atOffsets: indexSet)
    }
    
    var sendSheetToBLEButton: some View {
        Button(action: {
            self.isShowingSheet.toggle()
        }, label: {
            Text("考勤")
            Image(systemName: "staroflife")
                .font(.subheadline)
        })
    }
}

struct CourseDetailStudentView_Previews: PreviewProvider {
    static var previews: some View {
        CourseStudentView(viewModel: TeacherCourseViewModel(teachNumber: "0002"), courseInfo: CourseResponseData())
    }
}
