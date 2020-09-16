//
//  LoginViewModel.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/15.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation
import Alamofire

class LoginViewModel: ObservableObject {
    
    @Published var form: LoginUser
    @Published var message: String = ""
    @Published var responseData: LoginResponseData?
    
    init(form: LoginUser) {
        self.form = form
    }
    
    func login(isValidAccount: @escaping (Bool) -> ()) {
        APIClient.studentLogin(username: form.username, password: form.password) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                isValidAccount(false)
            case .success(let loginResponse):
                self.message = loginResponse.msg
                self.responseData = loginResponse.data
                if loginResponse.code == 10000 {
                    UserDefaults.standard.setValue([
                        "username": self.form.username,
                        "password": self.form.password,
                    ], forKey: "account")
                    isValidAccount(true)
                } else {
                    isValidAccount(false)
                }
            }
        }
    }
    
}

struct LoginUser: Codable {
    var username: String
    var password: String
    var userType: UserType = .student
}

enum UserType: String, Identifiable, CaseIterable {
    case student = "学生"
    case teacher = "教师"
    case admin = "管理员"
    var id: String { self.rawValue }
}

extension UserType: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringForRowValues = try container.decode(String.self)
        
        switch stringForRowValues {
        case UserType.student.rawValue:
            self = .student
        case UserType.teacher.rawValue:
            self = .teacher
        default:
            self = .admin
        }
    }
}
