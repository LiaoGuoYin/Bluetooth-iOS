//
//  StudentRegisterViewModel.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/9.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class StudentRegisterViewModel: ObservableObject {
    
    @Published var form: StudentForm
    @Published var message: String = ""
    
    init(studentForm: StudentForm) {
        self.form = studentForm
    }
    
    func clear() {
        self.form = StudentForm()
    }
    
    func submitForm(isValid: @escaping (Bool) -> () ) {
        APIClient.studentRegist(form: self.form) { (result) in
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
