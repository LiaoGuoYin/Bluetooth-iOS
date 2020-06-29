//
//  CourseStudentView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct CourseStudentView: View {
    @State var students: Array<Student>
    @State private var selections = Set<Student>()
    
    var body: some View {
        List(selection: $selections) {
            ForEach(self.students, id: \.userid) { (student: Student) in
                HStack(spacing: 16) {
                    Text(student.name)
                        .font(.headline)
                    Text(student.iClass)
                        .font(.subheadline)
                    Spacer()
                    Text(student.status ?? "")
                }
                .padding()
            }
            .onMove(perform: onMove)
            .onDelete(perform: onDelete)
        }
        .navigationBarTitle(Text("学生名单"))
        .navigationBarItems(trailing: EditButton())
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        self.students.move(fromOffsets: source, toOffset: destination)
    }
    
    private func onDelete(offsets: IndexSet) {
        if let first = offsets.first {
            self.students.remove(at: first)
        }
    }
    
}

//struct StudentsManagementView_Previews: PreviewProvider {
//    //    @State var students = studentsDemo
//    static var previews: some View {
//        CourseStudentView(students: studentsDemo)
//    }
//}
