//
//  StudentSignAppealForm.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/25.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentSignAppealForm: View {
    
    @State var sign: SignListResponseData
    @State var isShowAlert: Bool = false
    @State private var teacherName: String = ""
    @State private var message: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HistoryBlockRow(sign: sign)
                    HStack {
                        Text("老师全名: ")
                        TextField("张三", text: $teacherName)
                    }
                }
                .padding()
                
                Button(action: submitAppeal) {
                    HStack {
                        Spacer()
                        Text("提交")
                        Spacer()
                    }
                }
            }
        }
        .alert(isPresented: $isShowAlert, content: {
            Alert(title: Text("操作结果"), message: Text(message), dismissButton: .default(Text("OK")))
        })
    }
}

extension StudentSignAppealForm {
    func submitAppeal() {
        APIClient.studentSignAppeal(sign: sign, teacherName: teacherName) { (result) in
            switch result {
            case .failure(let error):
                message = error.localizedDescription
                self.isShowAlert.toggle()
            case .success(let messageResponse):
                message = messageResponse.msg
                self.isShowAlert.toggle()
            }
        }
    }
}

struct StudentSignAppealForm_Previews: PreviewProvider {
    static var previews: some View {
        let signDemoData = """
{
      "_id": "5e879df7b682a30811095261",
      "tNumber": "0001",
      "course": "高等数学上",
      "sName": "艾思译",
      "iClass": "信管研192",
      "sNumber": "471920358",
      "sMac": "BC:E1:43:B4:62:10",
      "sStatus": "1",
      "date": "1600829266662",
      "datetime": 1585946103284
    }
""".data(using: .utf8)!
        let signDemo = try! JSONDecoder().decode(SignListResponseData.self, from: signDemoData)
        return StudentSignAppealForm(sign: signDemo)
    }
}
