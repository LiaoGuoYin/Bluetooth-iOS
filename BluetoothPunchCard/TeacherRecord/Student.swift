//
//  Student.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation


struct Student {
    var name: String
    var iClass: String
    var userid: String
    var mac: String
    var status: String?
}

var CSVDemo = """
姓名,班级,学号,MAC,status
欧珀,电信研181,471820336,4c1a3d493e6c,√
吴埃斯,电信研183,123456778,BCE143B46210,√
吴一帆,工商研183,123456789,7836CC44578C,
杨清雷,土木研183,234567890,3CA581792440,
张世晔,英语研183,345678901,D461DA37FC98,
霍泽生,数学研183,456789112,A4504689B81F,
吕英鑫,工管研183,123231132,9487E09F9B02,√
初殿宇,法学研183,234563457,A4933F817F83,
刘埃斯,工商研184,225039186,044BED769B5E,
方彦瑾,安全研183,345678922,9CE82B8128AC,
铁牛,电控研181,863487827,4404446AA450,
袁超,安全研183,683268688,482CA03CDEB7,√
唐玉莲,工管研183,671256411,F4BF8008D846,
周雪,财贸研183,67136728,047970E090B6,
潘佳欣,法学研183,315263533,A4933F818390,
皮克嗖,英语研185,527737383,B4F1DA9A361D,√
维沃,机械研182,352033185,488764443630,
十一,电信研188,342708190,B87BC5C6303B,√
"""

/// 反序列化 studentCSV 为对象
/// - Parameter studentCSV: 学生名单字符串
func createDemoStudent(studentCSV: String) -> Array<Student> {
    var students = Array<Student>()
    var student = Student(name: "", iClass: "", userid: "", mac: "")

    let record = studentCSV.split(separator: "\n")
    for index in (1..<record.count) {
        let record = record[index].split(separator: ",")
        student.name = String(record[0])
        student.iClass = String(record[1])
        student.userid = String(record[2])
        student.mac = String(record[3])

        if record.count == 5 {
            student.status = String(record[4])
        } else {
            student.status = nil
        }

        students.append(student)
    }

    return students

}

func createDemoCourse(_ students: Array<Student>) -> TeacherCourse.Course {
    return TeacherCourse.Course(name: "Java程序设计", classes: "电信17-2、信管17-2", students: students, historyRecords: nil)
}

var studentsDemo = createDemoStudent(studentCSV: CSVDemo)
var courseDemo = createDemoCourse(studentsDemo)
