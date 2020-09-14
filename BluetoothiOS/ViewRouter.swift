//
//  ViewRouter.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewRouter, Never>()
    
    var currentView = "page" {
        didSet {
            self.objectWillChange.send(self)
        }
    }
    
    var isLogined = false {
        didSet {
            self.objectWillChange.send(self)
        }
    }
    
}
