//
//  AdminViewModel.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/25.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class AdminViewModel: ObservableObject {
    
    @Published var signList: Array<AdminSignListResponseData> = []
    @Published var macModifyList: Array<AdminMacManagerResponseData> = []
    @Published var message: String = ""
    
    
    init() {
        refreshRemoteMacModifyList()
        refreshRemoteSignAppealList()
    }
    
    func refreshRemoteSignAppealList() {
        APIClient.adminProcessSignAppeal { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let sign):
                self.signList = sign.data
            }
        }
    }
    
    func refreshRemoteMacModifyList() {
        APIClient.adminProcessMacModify { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let macResponse):
                self.macModifyList = macResponse.data
            }
        }
    }
}

