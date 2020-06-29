//
//  Course.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/26.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct TeacherCourse {
    var courses: Array<Course> = []

    struct Course {
        var id = UUID()
        var name: String
        var classes: String
        var students: Array<Student>?
        var capacity: Int {
            students?.count ?? 0
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
