//
//  RankListView.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/18.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct RankListView: View {
    var nameList: [String] = ["nil", "鼻涕龙", "猫猫", "天涯人", "达克鸭", "晴天霹雳", "阿勇", "眉老鼠", "我"]
    var stepList: [String] = ["nil", "5340", "5230", "4935", "4302", "3202", "1930", "820", "64"]
    
    var body: some View {
        VStack {
            List(1 ..< 9) { item in
                VStack {
                    HStack(spacing: 16) {
                        Text("\(item)")
                        Image("\(item)")
                            .clipShape(Circle())
                        Text("\(self.nameList[item])")
                        Spacer()
                        Text("\(self.stepList[item])")
                    }
                    .foregroundColor(Color(.white))
                    .padding()
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                }
            }
            Text("- 没有更多好友啦 -")
                .font(.caption)
                .foregroundColor(Color.black.opacity(0.3))
                .padding()
        }
    }
}

struct RankListView_Previews: PreviewProvider {
    static var previews: some View {
        RankListView()
    }
}
