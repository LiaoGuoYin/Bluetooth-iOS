//
//  StudentSignHistoryView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentSignHistoryView: View {
    @State var viewModel: StudentSignHistoryViewModel
    var body: some View {
        List {
            Section(header: Text("点击失败记录进行申诉")) {
                ForEach(viewModel.signList.reversed(), id: \.id) { record in
                    if record.status {
                        HistoryBlockRow(sign: record)
                    } else {
                        NavigationLink(
                            destination: StudentSignAppealFormView(sign: record),
                            label: {
                                HistoryBlockRow(sign: record)
                            })
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("所有考勤记录"), displayMode: .inline)
        .navigationBarItems(trailing: refreshRecordButton)
        .onAppear(perform: viewModel.refreshRemoteSignHistoryRecord)
    }
    
    var refreshRecordButton: some View {
        Button(action: viewModel.refreshRemoteSignHistoryRecord) {
            Text("刷新")
        }
    }
}

struct HistoryBlockRow: View {
    @State var sign: SignListResponseData
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(sign.courseName)
                    .font(.headline)
                Text((sign.studentName ?? "") + " " + (sign.mac ?? "None MAC"))
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

struct CoursePunchCardHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StudentSignHistoryView(viewModel: StudentSignHistoryViewModel(studentNumber: "0002"))
    }
}

