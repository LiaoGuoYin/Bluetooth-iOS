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
    @State private var tappedIndex: Int = -1
    var username = "1001"
    
    var body: some View {
        List {
            Section(header: Text("历史考勤记录")) {
                ForEach(0..<(signList.count)) { index in
                    HistoryBlockRow(sign: signList[index], index: index)
                        .onTapGesture(perform: {
                            self.isShowAppeal.toggle()
                            self.tappedIndex = index
                        })
                }
                .padding()
                .alert(isPresented: $isShowAppeal, content: {
                    Alert(title: Text("记录有误？"),
                          message: Text("是否申诉本条记录 \(tappedIndex)"),
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
        StudentRecordHistoryView(signList: [SignListResponseData(id: "29930", tNumber: "94", courseName: "Swift", sName: "Swift New", iClass: nil, sNumber: "1001", sMAC: "12:34:sd:sf:s2:cj", status: "0", date: "1600599685337", datetime: 1585792859305)])
    }
}

struct HistoryBlockRow: View {
    
    @State var sign: SignListResponseData
    @State var index: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(sign.courseName)
                Text(String(sign.datetime))
                Text("第 \(index) 次上课")
            }
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.blue)
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
