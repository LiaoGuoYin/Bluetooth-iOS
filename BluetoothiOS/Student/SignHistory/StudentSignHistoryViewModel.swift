//
//  StudentSignHistoryViewModel.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/25.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class StudentSignHistoryViewModel: ObservableObject {
    
    @Published var signList: Array<SignListResponseData> = []
    @Published var studentNumber: String = ""
    @Published var message: String = ""
    
    init(studentNumber: String) {
        self.studentNumber = studentNumber
        refreshRemoteSignHistoryRecord()
    }
    
    func refreshRemoteSignHistoryRecord() {
        APIClient.studentSignList(username: studentNumber) { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let signResponse):
                self.signList = signResponse.data
            }
        }
    }
}
