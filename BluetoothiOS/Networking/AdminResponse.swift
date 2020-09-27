//
//  AdminResponse.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/25.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct AdminMacManagerResponse: Codable {
    var code: Int
    var msg: String
    var data: [AdminMacManagerResponseData] = []
}

struct AdminMacManagerResponseData: Codable {
    var id: String
    var studentNumber: String
    var type: String
    var mac: String
    var isPassed: Bool
    var datetime: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case studentNumber = "number"
        case mac = "data"
        case type
        case isPassed = "status"
        case datetime
    }
}

extension AdminMacManagerResponseData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        studentNumber = try  container.decode(String.self, forKey: .studentNumber)
        type = try container.decode(String.self, forKey: .type)
        mac = try container.decode(String.self, forKey: .mac)
        
        let status = try container.decode(Int.self, forKey: .isPassed)
        isPassed = (status == 1) ? true : false
        
        let tmpDatetime = try container.decode(Int.self, forKey: .datetime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datetime = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(Int(tmpDatetime / 1000))))
    }
}

struct AdminLoginResponse: Codable {
    var code: Int
    var msg: String
    var data: AdminLoginForm?
}

struct AdminLoginForm: Codable {
    var number: String
    var passwd: String
}



struct AdminSignListResponse: Codable {
    var code: Int
    var msg: String
    var data: [AdminSignListResponseData]
}

struct AdminSignListResponseData: Codable {
    let id, teacherNumber: String
    let studentNumber: String?
    let studentName, mac: String?
    let courseName: String
    let classOf: String?
    let status: Bool
    let datetimeString: String
    let datetime: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case teacherNumber = "tNumber"
        case studentNumber = "sNumber"
        case studentName = "sName"
        case mac = "sMac"
        case courseName = "course"
        case classOf = "iClass"
        case status
        case datetimeString = "date"
        case datetime
    }
}

extension AdminSignListResponseData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        teacherNumber = try container.decode(String.self, forKey: .teacherNumber)
        studentNumber = try? container.decode(String.self, forKey: .studentNumber)
        studentName = try? container.decode(String.self, forKey: .studentName)
        courseName = try container.decode(String.self, forKey: .courseName)
        classOf = try? container.decode(String.self, forKey: .classOf)
        mac = try? container.decode(String.self, forKey: .mac)
        _ = try container.decode(Int.self, forKey: .datetimeString)
        
        let tmpDatetime = try container.decode(Int.self, forKey: .datetime)
        let tmpDate = Date(timeIntervalSince1970: TimeInterval(Int(tmpDatetime / 1000)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datetime = dateFormatter.string(from: tmpDate)
        
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        datetimeString = dateFormatter.string(from: tmpDate)
        
        let tmpStatus = try container.decode(Int.self, forKey: .status)
        status = (tmpStatus == 1) ? true: false
    }
}
