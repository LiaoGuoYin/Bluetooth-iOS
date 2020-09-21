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
    let id, tNumber: String
    let courseName: String
    let sName: String
    let iClass: String?
    let sNumber: String
    let sMAC: String
    let status, date: String
    let datetime: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tNumber, sName, iClass, sNumber
        case courseName = "course"
        case sMAC = "sMac"
        case status = "sStatus"
        case date, datetime
    }
}

