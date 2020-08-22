//
//  ViewModel.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/8/22.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class CourseStudentViewModel: ObservableObject {
    @Published var students: Array<Student>
    
    init(students: Array<Student>) {
        self.students = students
    }
}
