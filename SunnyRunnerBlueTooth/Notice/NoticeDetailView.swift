//
//  NoticeDetailView.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/3/19.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct NoticeRow: View {
    @State var notice: NoticeResponseSingleData
    
    var body: some View {
        NavigationLink(destination: NoticeDetailView(notice: self.notice)) {
            VStack(alignment: .leading, spacing: 10) {
                Text(self.notice.detail.title)
                    .font(.headline)
                    .lineLimit(2)
                HStack {
                    Spacer()
                    Text(self.notice.detail.date)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct NoticeDetailView: View {
    @State var notice: NoticeResponseSingleData
    
    var body: some View {
        ScrollView {
            VStack {
                Text(self.notice.detail.title)
                    .font(.title)
                Text(self.notice.detail.date)
                Text(self.notice.detail.content)
                    .font(.body)
                HStack() {
                    Text("原文地址：\(self.notice.url)")
                    Spacer()
                }
            }
            .padding()
        }
    }
}
