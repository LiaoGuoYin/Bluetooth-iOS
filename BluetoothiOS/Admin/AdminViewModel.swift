//
//  AdminViewModel.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/25.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class AdminViewModel: ObservableObject {
    
    @Published var signList: Array<SignListResponseData> = []
    @Published var signAppealList: Array<AdminSignAppealListResponseData> = []
    @Published var macModifyList: Array<AdminMacManagerResponseData> = []
    @Published var message: String = ""
    
    
    init() {
        refreshRemoteSignList()
        refreshRemoteMacModifyList()
        refreshRemoteSignAppealList()
    }
    
    
    func refreshRemoteSignList() {
        APIClient.adminGetSignList { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let signListResponse):
                self.signList = signListResponse.data
            }
        }
    }
    
    func refreshRemoteSignAppealList() {
        APIClient.adminProcessSignAppeal { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let signResponse):
                self.signAppealList = signResponse.data
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

