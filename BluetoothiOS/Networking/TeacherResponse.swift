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
