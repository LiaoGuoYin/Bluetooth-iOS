//
//  StudentRecordHistoryView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentRecordHistoryView: View {
    @State var isShowAppeal: Bool = false
    @State private var tappedIndex: Int = -1
    
    var body: some View {
        List {
            Section(header: Text("历史考勤记录")) {
                ForEach(1..<6) { index in
                    HStack {
                        HistoryBlockRow(courseCount: index)
                    }
                    .onTapGesture(perform: {
                        self.isShowAppeal.toggle()
                        self.tappedIndex = index
                    })
                }
                .padding()
                .alert(isPresented: self.$isShowAppeal, content: {
                    Alert(title: Text("记录有误？"), message: Text("是否申诉本条记录 \(tappedIndex)"), primaryButton: Alert.Button.destructive(Text("申诉"), action: {
                        
                    }),
                    secondaryButton: Alert.Button.default(Text("不用了")))
                })
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("考勤记录"), displayMode: .inline)
    }
}

struct CoursePunchCardHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRecordHistoryView()
    }
}

struct HistoryBlockRow: View {
    @State var courseDate: String
    @State var courseCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("第 \(self.courseCount) 次上课")
                Text(courseDate)
            }
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.blue)
        }
    }
}

extension HistoryBlockRow {
    init() {
        self.init(courseDate: "2020-04-07 9:48 周一", courseCount: -1)
    }
    
    init(courseCount: Int) {
        self.init(courseDate: "2020-04-07 9:48 周一", courseCount: courseCount)
        self.courseCount = courseCount
    }
}
