//
//  CourseViewModel.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/26.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class CourseViewModel: ObservableObject {
    @Published var teacherCourse: TeacherCourse
    @Published var students: Array<Student>
    @Published var course: TeacherCourse.Course
    
    init(_ course: TeacherCourse.Course) {
        self.teacherCourse = TeacherCourse(courses: [course])
        self.students = Array<Student>()
        self.course = course
    }
    
    convenience init() {
        self.init(TeacherCourse.Course(name: "", classes: ""))
    }
    
    //    MARK: - Access to the model
    var courses: Array<TeacherCourse.Course> {
        return teacherCourse.courses
    }
    
    //    MARK: - Intents
    func addCourse(_ course: TeacherCourse.Course) {
        self.teacherCourse.addCourse(course)
    }
    
    func deleteCourse(_ courseIndex: Int) {
        self.teacherCourse.deleteCourse(courseIndex)
    }
    
    func moveCourse(from source: IndexSet, to destination: Int) {
        self.teacherCourse.moveCourse(from: source, to: destination)
    }
    
    func addStudent(_ student: Student) {
        self.students.append(student)
    }
    
    func deleteStudent(_ studentIndex: Int) {
        self.students.remove(at: studentIndex)
    }
    
    func moveStudent(from source: IndexSet, to destination: Int) {
        self.students.move(fromOffsets: source, toOffset: destination)
    }
}

struct TeacherCourse {
    var courses: Array<Course> = []
    
    struct Course {
        var id = UUID()
        var name: String
        var classes: String
        var students: Array<Student> = []
        var capacity: Int {
            students.count
        }
        var historyRecords: Array<TeacherCourse.HistoryRecord>?
    }
    
    mutating func addCourse(_ course: Course) {
        self.courses.append(course)
    }
    
    mutating func deleteCourse(_ courseIndex: Int) {
        self.courses.remove(at: courseIndex)
    }
    
    mutating func moveCourse(from source: IndexSet, to destination: Int) {
        self.courses.move(fromOffsets: source, toOffset: destination)
    }
    
    struct HistoryRecord {
        var index: Int
        var dateTime: String
        var description: String
    }
    
}

extension TeacherCourse.Course: Hashable {
    static func == (lhs: TeacherCourse.Course, rhs: TeacherCourse.Course) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
