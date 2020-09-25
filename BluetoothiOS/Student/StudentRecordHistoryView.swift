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
    @State var username: String
    @State private var tappedId: String = ""
    
    var body: some View {
        List {
            Section(header: Text("历史考勤")) {
                ForEach(signList, id: \.id) { record in
                    NavigationLink(
                        destination: StudentSignAppealForm(sign: record),
                        label: {
                            HistoryBlockRow(sign: record)
                        })
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("所有签到记录"), displayMode: .inline)
        .onAppear(perform: loadRemoteSignHistoryRecord)
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

struct CoursePunchCardHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRecordHistoryView(signList: [], username: "1001")
    }
}
