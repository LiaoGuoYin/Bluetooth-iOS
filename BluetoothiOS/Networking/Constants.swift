//
//  Constants.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/15.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
//        static let baseURL = "http://10.31.86.31"
        static let baseURL = "https://www.hushtime.cn"
    }
    
    struct APIParameterKey {
        static let username = "number"
        static let password = "passwd"
    }
    
    struct StudentParameterKey {
        static let number = "number"
        static let password = "passwd"
        static let name = "name"
        static let mac = "mac"
        static let iClass = "iClass"
        static let phone = "phone"
        static let studentNumber = "sNumber"
        static let newMac = "newMac"
        static let date = "date"
    }
    
    struct TeacherParmeterKey {
        static let teacherName = "tName"
        static let className = "iClass"
        static let classroom = "classroom"
        static let courseName = "course"
    }
}

enum ContentType: String {
    case json = "application/json"
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}
