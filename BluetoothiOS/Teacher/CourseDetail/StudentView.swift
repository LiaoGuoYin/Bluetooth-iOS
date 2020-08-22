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
            ForEach(students, id: \.id) { (item: Student) in
                HStack(spacing: 16) {
                    Text(item.name)
                        .font(.headline)
                        .frame(width: 80)
                    Text(item.classOf)
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: item.status.rawValue == Student.Status.present.rawValue ? "checkmark.seal.fill":"xmark.seal")
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .onMove(perform: onMove)
            .onDelete(perform: onDelete)
        }
        .navigationBarTitle(Text("学生名单"))
        .navigationBarItems(trailing: EditButton())
    }
}

extension CourseStudentView {
        init() {
            self.init(students: studentsDemo)
        }
    
    private func onMove(source: IndexSet, destination: Int) {
        students.move(fromOffsets: source, toOffset: destination)
    }
    
    private func onDelete(offsets: IndexSet) {
        if let first = offsets.first {
            students.remove(at: first)
        }
    }
}

struct StudentsManagementView_Previews: PreviewProvider {
    static var previews: some View {
        CourseStudentView()
    }
}
