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
        static let innderBaseURL = "http://10.31.86.31"
        static let outerBaseURL = "https://www.hushtime.cn"
        static var baseURL = innderBaseURL
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
        static let id = "id"
        static let process = "process"
    }
    
    struct TeacherParmeterKey {
        static let teacherName = "tName"
        static let className = "iClass"
        static let classroom = "classroom"
        static let courseName = "course"
        static let signList = "signlist"
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

enum ServerModeEnum: String, CaseIterable, Identifiable {
    case inner = "校内模式"
    case outer = "校外模式"
    var id: String { self.rawValue }
}
