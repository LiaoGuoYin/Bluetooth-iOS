//
//  PunchCardView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/5.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct PunchCardView: View {
    var body: some View {
        NavigationView {
            List {
                Text("当前 MAC地址：\n\(UIDevice.current.identifierForVendor!)")
//                    TODO
                    .padding(8)
                
                Section(header: Text("附近发现的蓝牙考勤器")) {
                    ImageAndTextView(imageName: "dot.radiowaves.right", textName: "尔雅楼101")
                    ImageAndTextView(imageName: "dot.radiowaves.right", textName: "尔雅楼102")
                    ImageAndTextView(imageName: "radiowaves.right", textName: "尔雅楼201")
                    ImageAndTextView(imageName: "radiowaves.right", textName: "尔雅楼202")
                }
                .padding(8)
                
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("蓝牙打卡")
            
        }
    }
}

struct PunchCardView_Previews: PreviewProvider {
    static var previews: some View {
        PunchCardView()
    }
}
