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
        static let baseURL = "http://10.31.86.31"
    }
    
    struct APIParameterKey {
        static let username = "number"
        static let password = "passwd"
    }
    
    struct StudentRegisterParameterKey {
        static let number = "number"
        static let password = "passwd"
        static let name = "name"
        static let mac = "mac"
        static let iClass = "iClass"
        static let phone = "phone"
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
