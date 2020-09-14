//
//  TeacherForm.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/13.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation
import Alamofire

class TechearFormViewModel: ObservableObject {
    @Published var form: TeacherForm
    
    init(form: TeacherForm) {
        self.form = TeacherForm()
    }
    
    func clear() {
        self.form = TeacherForm()
    }
    
    func submitForRequest(teacherForm: TeacherForm) {
        APIClient.login(username: "1001", password: "admin") { result in
            switch result {
            case .success(let loginResponse):
                print(loginResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct TeacherForm: Codable {
    var id: String // 工号
    var name:  String
    var phone: String
    var password: String
    var rePassword: String
}

extension TeacherForm {
    init() {
        self.init(id: "", name: "", phone: "", password: "", rePassword: "")
    }
}
