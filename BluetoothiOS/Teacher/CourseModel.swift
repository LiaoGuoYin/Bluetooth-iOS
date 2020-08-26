//
//  Model.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/8/22.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct Course {
    var id = UUID()
    var name: String
    var classOf: String
    var students: Array<Student>
    var capacity: Int {
        get {
            students.count
        }
    }
    var historyRecords: Array<Course.HistoryRecord>?
    struct HistoryRecord {
        var index: Int
        var dateTime: String
        var description: String
    }
}

extension Course: Hashable {
    init() {
        self.init(name: "Swift 程序设计", classOf: "测试班级", students: Array<Student>())
    }
    
    init(students: Array<Student>) {
        self.init()
        self.students = students
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    mutating func clear() {
        self.name = ""
        self.classOf = ""
        self.students = []
        self.historyRecords = nil
    }
}
