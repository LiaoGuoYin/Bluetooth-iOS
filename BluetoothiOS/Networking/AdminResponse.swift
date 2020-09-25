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
