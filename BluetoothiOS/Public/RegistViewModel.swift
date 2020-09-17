//
//  RegistViewModel.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/16.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class RegistViewModel: ObservableObject {
    
    @Published var form: StudentForm
    @Published var userType: UserType = UserType.student
    @Published var message: String = ""
    
    init(_ form: StudentForm, userType: UserType) {
        self.form = form
        self.userType = userType
    }
    
    func clear() {
        self.form = StudentForm()
    }
    
    func submitForm(isValid: @escaping (Bool) -> ()) {
        if userType == UserType.student {
            APIClient.studentRegist(form: form) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                    isValid(false)
                case .success(let registResponse):
                    self.message = registResponse.msg
                    if registResponse.code == 10000 {
                        isValid(true)
                    } else {
                        isValid(false)
                    }
                }
            }
        } else {
            APIClient.teacherRegist(form: form) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                    isValid(false)
                case .success(let registResponse):
                    self.message = registResponse.msg
                    if registResponse.code == 10000 {
                        isValid(true)
                    } else {
                        isValid(false)
                    }
                }
            }
        }
    }
    
//    func checkForm() -> String {
//        //        if self.viewModel.form.password != self.viewModel.form.rePassword {
//        //            return "密码不一致"
//        //        }
//        if self.viewModel.form.id.count > 5 {
//            return "工号长度不正确"
//        }
//        //        if self.viewModel.form.phone.count != 11 {
//        //            return "手机长度不正确"
//        //        }
//        return "true"
//    }
    
}

struct StudentForm: Codable {
    var number: String
    var name:  String
    var mac: String
    var iClass: String
    var password: String
    var phone: String
    //    var college: College
}

extension StudentForm {
    init() {
        self.init(number: "0", name: "张三", mac: "", iClass: "", password: "", phone: "")
    }
}

enum College: String, Identifiable, CaseIterable {
    case computer = "计算机学院"
    case business = "工商管理学院"
    case mining = "矿业技术学院"
    case telecommunication = "电子与信息工程学院"
    var id: String {self.rawValue}
}

extension College: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringForRowValues = try container.decode(String.self)
        
        switch stringForRowValues {
        case College.computer.rawValue:
            self = .computer
        case College.business.rawValue:
            self = .business
        case College.mining.rawValue:
            self = .mining
        default:
            self = .mining
        }
    }
}
