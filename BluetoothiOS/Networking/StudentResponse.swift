//
//  StudentResponse.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/22.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct SignListResponse: Codable {
    let code: Int
    let msg: String
    let data: [SignListResponseData]
}

struct SignListResponseData: Codable {
    let id, teacherNumber: String
    let studentNumber, studentName, mac: String
    let courseName: String
    let classOf: String?
    let status: Bool
    let date: String
    let datetime: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case teacherNumber = "tNumber"
        case studentNumber = "sNumber"
        case studentName = "sName"
        case mac = "sMac"
        case courseName = "course"
        case classOf = "iClass"
        case status = "sStatus"
        case date
        case datetime
    }
}

extension SignListResponseData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        teacherNumber = try container.decode(String.self, forKey: .teacherNumber)
        studentNumber = try container.decode(String.self, forKey: .studentNumber)
        studentName = try container.decode(String.self, forKey: .studentName)
        courseName = try container.decode(String.self, forKey: .courseName)
        classOf = try? container.decode(String.self, forKey: .classOf)
        mac = try container.decode(String.self, forKey: .mac)
        date = try container.decode(String.self, forKey: .date)
        datetime = try container.decode(Int.self, forKey: .datetime)
        
        let tmpStatus = try container.decode(String.self, forKey: .status)
        status = (tmpStatus == "0") ? true: false
    }
}
