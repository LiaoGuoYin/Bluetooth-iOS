//
//  LoginResponse.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/15.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    var code: Int
    var msg: String
    var data: LoginResponseData?
}

// MARK: - LoginResponseData
struct LoginResponseData: Codable, CustomStringConvertible, Hashable {
    let id, number, passwd, name: String
    let iClass, mac, phone: String?
    let datetime: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case number, passwd, name, iClass, mac, datetime, phone
    }
    
    var description: String {
        /*
         姓名,班级,学号,MAC,\r
         丁一,111,1,BCE143B46210,√\r
         吴一帆,183,2,7836CC44578C,\r
         */
        return "\(name),\(iClass ?? "未知班级"),\(number),\(mac?.split(separator: ":").joined(separator: "") ?? ""),\r"
    }
    
}
