//
//  NoticeView.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/3/17.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct NoticeView: View {
    @ObservedObject var noticeItem: NoticeItem
    
    var body: some View {
        NavigationView {
            List {
                Section(header: HStack {
                    SectionTextAndImage(name: "教务新闻", image: "tag.fill")
                    Spacer()
                }
                .listRowInsets(EdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 0,
                    trailing: 0))
                ) {
                    ForEach(self.noticeItem.noticeList, id: \.url) { notice in
                        NoticeRow(notice: notice)
                            .padding()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("News", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                self.refreshToGetData()
            }) {
                Image(systemName: "goforward")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color(.systemBlue))
        .onAppear(perform: loadWithLocalData)
    }
}

extension NoticeView: DataProtocol {
    
    func refreshToGetData() {
        APIService.shared.getNotice { (response: NoticeResponse) in
            if let responseData = response.data {
                self.noticeItem.noticeList.removeAll()
                for notice in responseData {
                    self.noticeItem.noticeList.append(notice)
                }
                self.preserveToLocalData()
            }
        }
    }
    
    func preserveToLocalData() {
        do {
            let noticeItemData = try JSONEncoder().encode(self.noticeItem)
            try noticeItemData.write(to: noticeURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadWithLocalData() {
        print(NSHomeDirectory())
        if let localData = NSData(contentsOf: noticeURL) as Data? {
            do {
                let noticeItemNew = try JSONDecoder().decode(NoticeItem.self, from: localData)
                self.noticeItem.noticeList = noticeItemNew.noticeList
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct NoticeHeadCard: View {
    @State var adminNotice: String
    
    var body: some View {
        VStack {
            HStack {
                Image("Avatar")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                
                Text("Administration")
                Spacer()
            }
            .font(.headline)
            .foregroundColor(Color(.systemBlue))
            
            Text(adminNotice)
                .lineLimit(5)
                .padding()
            
        }
    }
}

struct NoticeView_Previews: PreviewProvider {
    
    static var previews: some View {
        NoticeView(noticeItem: NoticeItem(noticeList: noticeSample.data!))
    }
}
