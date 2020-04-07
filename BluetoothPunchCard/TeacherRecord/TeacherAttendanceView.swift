//
//  TeacherAttendanceView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TeacherAttendanceView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var isShowClassListAddSheet: Bool = false
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("课程列表")) {
                    NavigationLink(destination: CoursePunchCardHistoryView()) {
                        CourseRowBlockView()
                    }
                    
                    NavigationLink(destination: CoursePunchCardHistoryView()) {
                        CourseRowBlockView()
                    }
                    
                    NavigationLink(destination: CoursePunchCardHistoryView()) {
                        CourseRowBlockView()
                    }
                }
                .listRowBackground(Color(#colorLiteral(red: 0.9491460919, green: 0.9487624764, blue: 0.9704342484, alpha: 1)))
            }
            .listStyle(GroupedListStyle())
            .sheet(isPresented: self.$isShowClassListAddSheet, content: { CourseFormView() })
            .navigationBarTitle(Text("考勤管理"), displayMode: .inline)
            .navigationBarItems(trailing: addButton)
        }
    }
    
    var addButton: some View {
        Button(action: {
            self.isShowClassListAddSheet.toggle()
        }) {
            ZStack(alignment: .trailing) {
                Rectangle()
                    .fill(Color.blue.opacity(0.0001))
                    .frame(width: 48, height: 48)
                Image(systemName: "plus.square.fill.on.square.fill")
            }
        }
    }
    
}

struct TeacherAttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherAttendanceView()
    }
}
