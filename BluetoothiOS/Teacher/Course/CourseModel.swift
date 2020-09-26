//
//  Model.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/8/22.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

struct Course: Codable {
    var id = UUID()
    var name: String
    var classList: [String]
    var roomOf: String
}

extension Course: Hashable {
    init() {
        self.init(name: "Swift程序设计", classList: [], roomOf: "尔雅楼221")
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
