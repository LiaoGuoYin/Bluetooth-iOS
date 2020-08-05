//
//  TeacherMainView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TeacherMainView: View {
    @ObservedObject var viewModel: CourseViewModel
    @State private var isShowClassListAddSheet: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("课程列表")) {
                    ForEach(viewModel.courses, id: \.id) { (course: TeacherCourse.Course) in
                        NavigationLink(destination: CourseStudentView(students: course.students)) {
                            CourseRowBlockView(courseName: course.name, className: course.classes, classPeopleCount: course.capacity)
                        }
                    }
                    .onMove(perform: onMove)
                    .onDelete(perform: onDelete)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("考勤管理"))
            .navigationBarItems(trailing: addButton)
        }
        .sheet(isPresented: self.$isShowClassListAddSheet) {
            CourseFormView(viewModel: self.viewModel, form: TeacherCourse.Course(name: "", classes: ""))
        }
    }
}

extension TeacherMainView {
    init() {
        self.init(viewModel: CourseViewModel())
        self.viewModel.addCourse(courseDemo)
        self.viewModel.students = studentsDemo
    }
    
    func onMove(source: IndexSet, destination: Int) {
        self.viewModel.moveCourse(from: source, to: destination)
    }
    
    func onDelete(offsets: IndexSet) {
        if let first = offsets.first {
            self.viewModel.deleteCourse(first)
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

struct TeacherMainView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherMainView()
    }
}
