//
//  TeacherResponse.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/17.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct CourseResponse: Codable {
    let code: Int
    let msg: String
    let data: [CourseResponseData]
}

struct CourseResponseData: Codable {
    let name: String
    let status: String
    let datetime: Int
    let classList: [String]
    let roomOf: String
    
    enum CodingKeys: String, CodingKey {
        case name = "course"
        case status
        case datetime
        case roomOf = "classroom"
        case classList = "iClass"
    }
}

extension CourseResponseData {
    init() {
        self.init(name: "Swift程序设计", status: "0", datetime: 1234243, classList: ["电信研183", "信管研183"], roomOf: "尔雅221")
    }
}


struct ClassStudentResponse: Codable {
    let code: Int
    let msg: String
    let data: [LoginResponseData]
}
