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
struct LoginResponseData: Codable {
    let id, number, passwd, name: String
    let iClass, mac, phone: String?
    let datetime: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case number, passwd, name, iClass, mac, datetime, phone
    }
}
