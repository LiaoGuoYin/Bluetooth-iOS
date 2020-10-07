//
//  TeacherResponse.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/17.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct CourseResponse: Codable {
    var code: Int
    var msg: String
    var data: [CourseResponseData] = []
}

struct CourseResponseData: Codable {
    let name: String
    let status: Bool
    let datetime: String
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
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        classList = try container.decode([String].self, forKey: .classList)
        name = try container.decode(String.self, forKey: .name)
        roomOf = try container.decode(String.self, forKey: .roomOf)
        
        let tmpStatus = try container.decode(String.self, forKey: .status)
        status = (tmpStatus == "1") ? true: false
        
        let tmpTimeStamp = try container.decode(Int.self, forKey: .datetime)
        let tmpDatetime = Date(timeIntervalSince1970: TimeInterval(tmpTimeStamp / 1000))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datetime = dateFormatter.string(from: tmpDatetime)
    }
}

extension CourseResponseData {
    init() {
        self.init(name: "Swift程序设计", status: true, datetime: "1601039066805", classList: ["电信研183"], roomOf: "尔雅221")
    }
}

struct ClassStudentResponse: Codable {
    let code: Int
    let msg: String
    let data: [LoginResponseData]
}

struct ClassListResponse: Codable {
    let code: Int
    let msg: String
    let data: [String]
}

struct CourseRecord: Encodable {
    var teacherNumber: String
    var courseName: String
    var date: Int64 = Date().currentTimeMillis()
    var signList: [Student] = []
    
    enum CodingKeys: String, CodingKey {
        case teacherNumber = "number"
        case courseName = "course"
        case date
        case signList = "signlist"
    }
}

extension CourseRecord {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(teacherNumber, forKey: .teacherNumber)
        try container.encode(courseName, forKey: .courseName)
        
        var signListContainer = container.nestedUnkeyedContainer(forKey: .signList)
        try self.signList.forEach({ (each) in
            try signListContainer.encode(each)
        })
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
