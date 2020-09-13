//
//  CourseStudentView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct CourseStudentView: View {
    @State var viewModel: TeacherCourseViewModel
    @Binding var students: Array<Student>
    @State private var isShowingSheet: Bool = false
    @State private var isShowNewPage: Bool = false
    
    
    var body: some View {
        List {
            ForEach(students, id: \.self) { (item: Student) in
                HStack(spacing: 16) {
                    Text(item.name)
                        .font(.headline)
                        .frame(width: 80)
                    VStack(alignment:.leading, spacing: 8) {
                        Text(item.classOf)
                            .font(.caption)
                        Text(item.mac)
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: item.status.rawValue == Student.Status.present.rawValue ? "checkmark.seal.fill":"xmark.seal")
                        .foregroundColor(.blue)
                }
                .padding()
                .onTapGesture(count: 2, perform: {
                    self.isShowingSheet.toggle()
                })
            }
            .onMove(perform: onMoveStudent)
            .onDelete(perform: onDeleteStudent)
        }
        .sheet(isPresented: self.$isShowNewPage, content: {
            BLEView()
        })
        .actionSheet(isPresented: $isShowingSheet, content: {
            ActionSheet(title: Text("是否开始考勤？"),
                        message: Text("当前班级学生：\(students.count) 人"),
                        buttons: [.default(Text("开始"), action: {
                            self.isShowNewPage.toggle()
                        }), .cancel(Text("取消"))])
        })
        .navigationBarTitle(Text("学生名单"))
        .navigationBarItems(trailing: sendSheetToBLEButton)
    }
}

extension CourseStudentView {
    private func onAdd(_ student: Student) {
        students.append(student)
    }
    
    private func onMoveStudent(source: IndexSet, destination: Int) {
        students.move(fromOffsets: source, toOffset: destination)
    }
    
    private func onDeleteStudent(at indexSet: IndexSet) {
        students.remove(atOffsets: indexSet)
    }
    
    var sendSheetToBLEButton: some View {
        Button(action: {
            self.isShowingSheet.toggle()
            let selectedCourseString = serializeStudentsToStringForSending(students: self.students)
            self.viewModel.sendStudentStringToBLE(of: selectedCourseString)
        }, label: {
            Text("考勤")
                .foregroundColor(.blue)
            Image(systemName: "staroflife")
                .font(.subheadline)
        })
    }
    
}

struct CourseDetailStudentView_Previews: PreviewProvider {
    static var previews: some View {
        CourseStudentView(viewModel: TeacherCourseViewModel(), students: .constant(studentsDemo))
    }
}
