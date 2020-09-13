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
    @State private var isShowCourseSheet: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section( header: Text("课程列表") ) {
                    ForEach(viewModel.courseList.indices, id:\.self) { index in
                        NavigationLink(destination:
                                        CourseStudentView(viewModel: viewModel, students: self.$viewModel.courseList[index].students)
                        ) {
                            TeacherCourseRowView(course: $viewModel.courseList[index])
                        }
                    }
                    .onMove(perform: onMoveCourse)
                    .onDelete(perform: onDeleteCourse)
                }
            }
            .navigationBarTitle(Text("考勤管理"), displayMode: .automatic)
            .navigationBarItems(leading: EditButton(),
                                trailing: addButton.foregroundColor(.blue))
        }
        .sheet(isPresented: $isShowCourseSheet) {
            NewCourseFormView(viewModel: self.viewModel)
        }
    }
}

extension TeacherCourseView {
    init() {
        self.init(viewModel: TeacherCourseViewModel())
        for _ in 1..<3 {
            viewModel.addCourse(Course())
        }
    }
    
    func loadLocalData() {
        
    }
    
    func onMoveCourse(source: IndexSet, destination: Int) {
        viewModel.moveCourse(from: source, to: destination)
    }
    
    func onDeleteCourse(at indexSet: IndexSet) {
        viewModel.deleteCourse(indexSet)
    }
    
    var addButton: some View {
        Button(action: { self.isShowCourseSheet.toggle() }) {
            Image(systemName: "plus.square")
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
        }
    }
}

struct TeacherCourseView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherCourseView()
    }
}
