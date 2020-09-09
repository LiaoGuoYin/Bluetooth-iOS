//
//  StudentFormViewModel.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/9.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class StudentFormViewModel: ObservableObject {
    @Published var form: StudentForm
    
    init(studentForm: StudentForm) {
        self.form = studentForm
    }
}
