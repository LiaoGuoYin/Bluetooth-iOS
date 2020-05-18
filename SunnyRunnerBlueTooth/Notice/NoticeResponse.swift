//
//  NoticeResponse.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/3/19.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class NoticeResponse: Codable {
    var code: Int
    var message: String
    var data: [NoticeResponseSingleData]?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
}

struct NoticeResponseSingleData: Codable {
    var url: String
    var detail: NoticeResponseSingleDataDetail

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case detail = "detail"
    }
}


struct NoticeResponseSingleDataDetail: Codable {
    var title: String
    var content: String
    var date: String
    var appendix: [NoticeResponseSingleDataDetailAppendix]?

    enum CodingKeys: String, CodingKey {
        case content = "content"
        case appendix = "appendix"
        case title = "title"
        case date = "date"
    }
}

struct NoticeResponseSingleDataDetailAppendix: Codable {
    var url: String
    var name: String

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case name = "name"
    }
}
