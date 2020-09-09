//
//  CourseStudentView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct CourseStudentView: View {
    @Binding var students: Array<Student>
    
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
            }
            .onMove(perform: onMoveStudent)
            .onDelete(perform: onDeleteStudent)
        }
        .navigationBarTitle(Text("学生名单"))
        .navigationBarItems(trailing: EditButton())
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
}
