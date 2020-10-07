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
    @Published var tappedMacModificationId: String = ""
    @Published var tappedAppealSignRecordId: String = ""

    
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
    
    func processSignAppeal() {
        APIClient.processSignAppeal(signId: tappedAppealSignRecordId) { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let macResponse):
                self.message = macResponse.msg
                self.refreshRemoteSignAppealList()
            }
        }
    }
    
    func processMacModification() {
        guard let macModification = self.macModifyList.filter({ $0.id == tappedMacModificationId }).first else {
            return
        }
        
        let macModificationRequest = MacModificationRequestData(id: macModification.id, studentNumber: macModification.studentNumber, mac: macModification.mac)
        APIClient.processMacModify(processMac: macModificationRequest) { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let macResponse):
                self.message = macResponse.msg
                self.refreshRemoteMacModifyList()
            }
        }
    }
}
