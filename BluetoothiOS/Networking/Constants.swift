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
        static let baseURL = "https://www.hushtime.cn"
        static let demoURL = "https://api.liaoguoyin.com"
    }
    
    struct APIParameterKey {
        static let username = "username"
        static let password = "password"
    }
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}