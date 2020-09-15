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
    
    init(form: LoginUser) {
        self.form = form
    }
    
    func checkAccount(isValidAccount: @escaping (Any) -> ()) {
        APIClient.studentLogin(username: form.username, password: form.passwd) { (result) in
            switch result {
            case .success(let loginResponse):
                print(loginResponse)
                isValidAccount(true)
            case .failure(let error):
                print(error)
                isValidAccount(false)
            }
        }
    }
    
}

struct LoginUser: Codable {
    var username: String
    var passwd: String
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
