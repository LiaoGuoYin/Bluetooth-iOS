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
    @State var isShowAppealForm: Bool = false
    @State var isShowAlert: Bool = false
    @State private var tappedId: String = ""
    var username = "471920358"
    
    var body: some View {
        List {
            Section(header: Text("历史考勤记录")) {
                ForEach(signList, id: \.id) { record in
                    HistoryBlockRow(sign: record)
                        .onTapGesture(perform: {
                            tappedId = record.id
                            self.isShowAlert.toggle()
                        })
                }
                .padding()
                .alert(isPresented: $isShowAlert, content: {
                    Alert(title: Text("记录有误？"),
                          message: Text("是否申诉本条记录"),
                          primaryButton: Alert.Button.destructive(Text("申诉"), action: {isShowAppealForm.toggle()}),
                          secondaryButton: Alert.Button.default(Text("不用了")))
                })
                .sheet(isPresented: $isShowAppealForm, content: {
                    StudentSignAppealForm(sign: signList.filter({ (sign: SignListResponseData) -> Bool in
                        return sign.id == tappedId
                    })[0])
                })
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("考勤记录"), displayMode: .inline)
        .onAppear(perform: loadRemoteSignHistoryRecord)
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
                    .font(.headline)
                Text(sign.studentName + " " + sign.mac)
                    .font(.subheadline)
                Text(sign.datetime)
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
