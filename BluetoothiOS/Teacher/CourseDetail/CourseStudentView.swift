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
    @State var classList: [String] = []
    @State var studentList: Array<Student> = []
    @State private var isShowingSheet: Bool = false
    @State private var isShowNewPage: Bool = false
    
    var body: some View {
        List {
            Section(header: Text("共计学生: \(studentList.count)")) {
                ForEach(studentList, id: \.id) { student in
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
                .onMove(perform: onMoveStudent)
                .onDelete(perform: onDeleteStudent)
            }
        }
        .listStyle(GroupedListStyle())
        .sheet(isPresented: self.$isShowNewPage, content: {
            BLEView(studentList: studentList, courseName: viewModel.form.name, teacherNumber: viewModel.teacherNumber)
        })
        .actionSheet(isPresented: $isShowingSheet, content: {
            ActionSheet(title: Text("是否开始考勤？"),
                        message: Text("当前班级学生：\(studentList.count) 人"),
                        buttons: [.default(Text("开始"), action: {
                            self.isShowNewPage.toggle()
                        }), .cancel(Text("取消"))])
        })
        .onAppear(perform: loadAllClass)
        .navigationBarTitle(Text("学生名单"))
        .navigationBarItems(trailing: sendSheetToBLEButton)
    }
}

extension CourseStudentView {
    
    init() {
        self.init(viewModel: TeacherCourseViewModel(teachNumber: "1001"))
    }
    
    func loadAllClass() {
        for each in classList {
            loadClassStudentList(className: each)
        }
    }
    
    func loadClassStudentList(className: String) {
        APIClient.teacherGetStudentListByClassName(className: className) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let studentListOfClass):
                self.studentList.append(contentsOf: studentListOfClass.data)
            }
        }
    }
    
    private func onAdd(_ student: Student) {
        studentList.append(student)
    }
    
    private func onMoveStudent(source: IndexSet, destination: Int) {
        studentList.move(fromOffsets: source, toOffset: destination)
    }
    
    private func onDeleteStudent(at indexSet: IndexSet) {
        studentList.remove(atOffsets: indexSet)
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
        CourseStudentView(viewModel: TeacherCourseViewModel(teachNumber: "1001"), classList: ["信管研192", "土木研193"])
    }
}
