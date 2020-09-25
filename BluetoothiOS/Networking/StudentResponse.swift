//
//  StudentResponse.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/22.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct SignListResponse: Codable {
    var code: Int
    var msg: String
    var data: [SignListResponseData] = []
}

struct SignListResponseData: Codable {
    let id, teacherNumber: String
    let studentNumber: String?
    let studentName, mac: String?
    let courseName: String
    let classOf: String?
    let status: Bool
    let timeStamp: Int
    let datetime: String
    let datetimeString: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case teacherNumber = "tNumber"
        case studentNumber = "sNumber"
        case studentName = "sName"
        case mac = "sMac"
        case courseName = "course"
        case classOf = "iClass"
        case status
        case timeStamp = "date"
        case datetime
        case datetimeString
    }
}

extension SignListResponseData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        teacherNumber = try container.decode(String.self, forKey: .teacherNumber)
        studentNumber = try? container.decode(String.self, forKey: .studentNumber)
        studentName = try? container.decode(String.self, forKey: .studentName)
        courseName = try container.decode(String.self, forKey: .courseName)
        classOf = try? container.decode(String.self, forKey: .classOf)
        mac = try? container.decode(String.self, forKey: .mac)
        timeStamp = try container.decode(Int.self, forKey: .timeStamp)
        let tmpDatetime = try container.decode(Int.self, forKey: .datetime)
        
        let date = Date(timeIntervalSince1970: TimeInterval(Int(tmpDatetime / 1000)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datetime = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        datetimeString = dateFormatter.string(from: date)
        
        let tmpStatus = try container.decode(Int.self, forKey: .status)
        status = (tmpStatus == 0) ? true: false
    }
}
