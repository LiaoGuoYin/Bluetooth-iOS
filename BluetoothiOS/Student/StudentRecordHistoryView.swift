//
//  StudentRecordHistoryView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentRecordHistoryView: View {
    var body: some View {
        List {
            Section(header: Text("历史考勤记录")) {
                ForEach(1..<6) { _ in
                    HStack {
                        HistoryBlockRow()
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct CoursePunchCardHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRecordHistoryView()
    }
}

struct HistoryBlockRow: View {
    @State var courseDate: String = "2020-04-07 9:48 周一"
    @State var courseCount: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("第 \(self.courseCount) 次上课")
            Text(courseDate)
        }
    }
}
