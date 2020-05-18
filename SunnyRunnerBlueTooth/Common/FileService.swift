//
//  FileService.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/3/31.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation


let manager = FileManager.default

let documentDirectoryURL = manager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]

var noticeURL: URL {
    return documentDirectoryURL.appendingPathComponent("notice")
}

var classTableURL: URL {
    return documentDirectoryURL.appendingPathComponent("classTable")
}

var gradeURL: URL {
    return documentDirectoryURL.appendingPathComponent("grade")
}

var infoURL: URL {
    return documentDirectoryURL.appendingPathComponent("info")
}

var accountURL: URL {
    return documentDirectoryURL.appendingPathComponent("account")
}
