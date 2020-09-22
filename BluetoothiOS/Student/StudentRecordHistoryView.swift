//
//  StudentRecordHistoryView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentRecordHistoryView: View {
    
    @State var signList: Array<SignListResponseData>
    @State var isShowAppeal: Bool = false
    var username = "471920358"
    
    var body: some View {
        List {
            Section(header: Text("历史考勤记录")) {
                ForEach(signList, id: \.id) { record in
                    HistoryBlockRow(sign: record)
                        .onTapGesture(perform: {
                            self.isShowAppeal.toggle()
                        })
                }
                .padding()
                .alert(isPresented: $isShowAppeal, content: {
                    Alert(title: Text("记录有误？"),
                          message: Text("是否申诉本条记录"),
                          primaryButton: Alert.Button.destructive(Text("申诉"), action: {}),
                          secondaryButton: Alert.Button.default(Text("不用了")))
                })
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("考勤记录"), displayMode: .inline)
        .onAppear(perform: {
            loadRemoteSignHistoryRecord()
        })
    }
}

struct CoursePunchCardHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRecordHistoryView(signList: [])
    }
}

struct HistoryBlockRow: View {
    
    @State var sign: SignListResponseData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(sign.courseName)
                Text(sign.studentName)
                Text(sign.mac)
                    .font(.caption)
                Text(String(sign.datetime))
                    .font(.caption)
            }
            Spacer()
            Image(systemName: (sign.status ? "checkmark.seal.fill" : "xmark.seal"))
                .foregroundColor(sign.status ? Color.blue : Color.pink.opacity(0.8))
        }
    }
}

extension StudentRecordHistoryView {
    func loadRemoteSignHistoryRecord() {
        APIClient.studentSignList(username: username) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signResponse):
                self.signList = signResponse.data
            }
        }
    }
}
//
//let demoCourseSignList = """
//[
//    {
//      "_id": "5e856e5acf0ad2099791b8ca",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600599685337",
//      "datetime": 1585802842014
//    },
//    {
//      "_id": "5e85475bcf0ad2099791b8c6",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": null,
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "0",
//      "date": "1600589702797",
//      "datetime": 1585792859305
//    },
//    {
//      "_id": "5e85462ccf0ad2099791b8be",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": null,
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "0",
//      "date": "1600589399808",
//      "datetime": 1585792556308
//    },
//    {
//      "_id": "5e8536bdcf0ad2099791b8b7",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600585448872",
//      "datetime": 1585788605270
//    },
//    {
//      "_id": "5e8536bdcf0ad2099791b8b1",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600585448827",
//      "datetime": 1585788605253
//    },
//    {
//      "_id": "5e853517cf0ad2099791b8ab",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600585027367",
//      "datetime": 1585788183753
//    },
//    {
//      "_id": "5e853517cf0ad2099791b8a5",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600585027326",
//      "datetime": 1585788183734
//    },
//    {
//      "_id": "5e853167cf0ad2099791b896",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600584082881",
//      "datetime": 1585787239280
//    },
//    {
//      "_id": "5e853094cf0ad2099791b891",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600583871728",
//      "datetime": 1585787028117
//    },
//    {
//      "_id": "5e852f54cf0ad2099791b88b",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600583552059",
//      "datetime": 1585786708442
//    },
//    {
//      "_id": "5e8501aacf0ad2099791b886",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": null,
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "0",
//      "date": "1600571862602",
//      "datetime": 1585775018767
//    },
//    {
//      "_id": "5e84fa3acf0ad2099791b87a",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": null,
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "0",
//      "date": "1600569958612",
//      "datetime": 1585773114744
//    },
//    {
//      "_id": "5e84f6cfcf0ad2099791b870",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600569083722",
//      "datetime": 1585772239838
//    },
//    {
//      "_id": "5e84d0b0cf0ad2099791b861",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600559325001",
//      "datetime": 1585762480961
//    },
//    {
//      "_id": "5e84d0b0cf0ad2099791b85b",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600559324947",
//      "datetime": 1585762480928
//    },
//    {
//      "_id": "5f62cf3ccdb3a5d22bf83c85",
//      "tNumber": "0001",
//      "course": "高等数学上",
//      "sName": "艾思译",
//      "iClass": "信管研192",
//      "sNumber": "471920358",
//      "sMac": "BC:E1:43:B4:62:10",
//      "sStatus": "1",
//      "date": "1600311104576",
//      "datetime": 1600311100878
//    }
//  ]
//""".data(using: .utf8)!
