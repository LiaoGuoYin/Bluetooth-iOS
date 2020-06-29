//
//  TeacherMainView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TeacherMainView: View {
    @State private var isShowClassListAddSheet: Bool = false
    @ObservedObject var viewModel = CourseViewModel(courseDemo)
    @State private var selections = Set<TeacherCourse.Course>()
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.clear
        let newCourse = TeacherCourse.Course(name: "Java程序设计", classes: "工商17-3")
        viewModel.addCourse(newCourse)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("课程列表")) {
                    ForEach(viewModel.courses, id: \.id) { (course) in
                        HStack {
                            CourseRowBlockView(courseName: course.name, className: course.classes, classPeopleCount: course.capacity)
                            NavigationLink(destination: StudentsManagementView()) {
                                EmptyView()
                            }
                            .frame(width: 0)
                        }
                    }
                    .onMove(perform: onMove)
                    .onDelete(perform: onDelete)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("考勤管理"))
            .navigationBarItems(leading: EditButton(), trailing: addButton)
            .sheet(isPresented: self.$isShowClassListAddSheet) {
                NewCourseFormView().environmentObject(self.viewModel)
            }
        }
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        self.viewModel.move(from: source, to: destination)
    }
    
    
    private func onDelete(offsets: IndexSet) {
        if let first = offsets.first {
            self.viewModel.deleteCourse(first)
        }
    }
    
    var addButton: some View {
        Button(action: { self.isShowClassListAddSheet.toggle() }) {
            Image(systemName: "plus.rectangle.on.rectangle")
                .font(.body)
                .padding(EdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 0))
        }
    }
}

struct TeacherMainView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherMainView()
    }
}
