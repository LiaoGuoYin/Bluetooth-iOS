//
//  TeacherForm.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/13.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class TechearFormViewModel: ObservableObject {
    @Published var form: TeacherForm
    
    init(form: TeacherForm) {
        self.form = TeacherForm()
    }
    
    func clear() {
        self.form = TeacherForm()
    }
    
}

struct TeacherForm {
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
