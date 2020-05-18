//
//  NoticeItem.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/3/27.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class NoticeItem: NSObject, ObservableObject, Codable {

    @Published var noticeList: [NoticeResponseSingleData]

    init(noticeList: [NoticeResponseSingleData]) {
        self.noticeList = noticeList
    }

    enum CodingKeys: String, CodingKey {
        case noticeList
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.noticeList = try container.decode([NoticeResponseSingleData].self, forKey: .noticeList)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.noticeList, forKey: .noticeList)
    }

}
