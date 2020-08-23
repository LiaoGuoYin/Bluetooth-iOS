//
//  TeacherCourseView.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TeacherCourseView: View {
    @ObservedObject var viewModel: TeacherCourseViewModel
    @State private var isShowClassListAddSheet: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("课程列表")) {
                    ForEach(self.viewModel.courseList, id: \.id) { item in
                        NavigationLink(destination:
                                        CourseStudentView(students: item.students)
                        ) {
                            TeacherCourseRowView(course: item)
                        }
                    }
                    .onMove(perform: onMove)
                    .onDelete(perform: onDelete)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("考勤管理"))
            .navigationBarItems(leading: EditButton(),trailing: addButton)
        }
        .sheet(isPresented: $isShowClassListAddSheet) {
            NewCourseFormView(viewModel: self.viewModel, form: Course())
        }
    }
}

extension TeacherCourseView {
    init() {
        self.init(viewModel: TeacherCourseViewModel())
        for _ in 1..<2 {
            viewModel.addCourse(Course(students: studentsDemo))
        }
    }
    
    func loadLocalData() {
        
    }
    
    func onMove(source: IndexSet, destination: Int) {
        viewModel.moveCourse(from: source, to: destination)
    }
    
    func onDelete(offsets: IndexSet) {
        if let first = offsets.first {
            viewModel.deleteCourse(first)
        }
    }
    
    var addButton: some View {
        Button(action: { self.isShowClassListAddSheet.toggle() }) {
            Image(systemName: "plus.square.fill")
                .font(.headline)
                .padding(EdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 0))
        }
    }
}

struct TeacherCourseView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherCourseView()
    }
}
