//
//  CourseViewModel.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/26.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class CourseViewModel: ObservableObject {
    @Published private(set) var teacherCourse: TeacherCourse
    @Published private(set) var students: Array<Student>

    init() {
        teacherCourse = TeacherCourse()
        students = []
    }
    
    init(_ course: TeacherCourse.Course) {
        teacherCourse = TeacherCourse(courses: [course])
        students = []
    }
    
    //    MARK: - Access to the model
    var courses: Array<TeacherCourse.Course> {
        return teacherCourse.courses
    }
    
    //    MARK: - Intents
    func addCourse(_ course: TeacherCourse.Course) {
        teacherCourse.addCourse(course)
    }
    
    func deleteCourse(_ courseIndex: Int) {
        teacherCourse.deleteCourse(courseIndex)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        teacherCourse.moveCourse(from: source, to: destination)
    }
    
}
