//
//  StudentsManagementView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentsManagementView: View {
    private var students: Array<Student> = studentsDemo
    var body: some View {
        List {
            ForEach(students, id: \.userid) { (student: Student) in
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
        }
        .navigationBarTitle(Text("学生名单"))
    }
}

struct StudentsManagementView_Previews: PreviewProvider {
    static var previews: some View {
        StudentsManagementView()
    }
}
