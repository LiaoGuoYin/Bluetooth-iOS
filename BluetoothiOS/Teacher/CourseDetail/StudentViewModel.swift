////
////  ViewModel.swift
////  BluetoothiOS
////
////  Created by LiaoGuoYin on 2020/8/22.
////  Copyright © 2020 LiaoGuoYin. All rights reserved.
////
//
//import Foundation
//
//class CourseStudentViewModel: ObservableObject {
//    @Published var studentList: Array<Student>
//
//    init(studentList: Array<Student>) {
//        self.studentList = studentList
//    }
//
//    //    MARK: - Intents
//    func add(_ student: Student) {
//        studentList.append(student)
//    }
//    
//    func delete(_ studentIndex: Int) {
//        studentList.remove(at: studentIndex)
//    }
//
//    func move(from source: IndexSet, to destination: Int) {
//        studentList.move(fromOffsets: source, toOffset: destination)
//    }
//
//}
