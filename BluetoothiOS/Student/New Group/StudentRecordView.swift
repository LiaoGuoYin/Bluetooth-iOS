//
//  StudentRecordView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/5.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct StudentRecordView: View {
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: .constant(1), label: Text("Picker")) {
                    Text("成功记录").tag(1)
                    Text("失败记录").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                List {
                    Text("0")
                    Text("1")
                    Text("2")
                }
            }
            .navigationBarTitle("Record")
        }
    }
}

struct StudentRecordView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRecordView()
    }
}
