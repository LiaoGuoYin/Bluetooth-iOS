//
//  CourseViewModel.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/26.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class CourseViewModel: ObservableObject {
    @Published private(set) var model: TeacherCourse
    
    init() {
        model = TeacherCourse()
    }
    
    init(_ course: TeacherCourse.Course) {
        model = TeacherCourse(courses: [course])
    }
    
    //    MARK: - Access to the model
    var courses: Array<TeacherCourse.Course> {
        model.courses
    }
    
    //    MARK: - Intents
    
    func addCourse(_ course: TeacherCourse.Course) {
        model.addCourse(course)
    }
    
    func deleteCourse(_ courseIndex: Int) {
        model.deleteCourse(courseIndex)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.moveCourse(from: source, to: destination)
    }
    
}
