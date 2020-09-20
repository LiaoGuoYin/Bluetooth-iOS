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
                Section(header: Text("课程列表") ) {
                    ForEach(0..<viewModel.courseList.count, id: \.self) { (index) in
                        VStack(spacing: 16) {
                            TeacherCourseRowView(course: $viewModel.courseList[index])
                            NavigationLink(
                                destination: CourseStudentView(viewModel: viewModel, classList: [viewModel.courseList[index].classList]),
                                label: {
                                    Text(viewModel.courseList[index].roomOf)
                                        .font(.subheadline)
                                })
                        }
                        .padding(.vertical, 12)
                    }
                    .onMove(perform: onMoveCourse)
                    .onDelete(perform: onDeleteCourse)
                }
            }
            .sheet(isPresented: $isShowCourseSheet) {
                NewCourseFormView(viewModel: self.viewModel)
            }
            .navigationBarTitle(Text("考勤管理"), displayMode: .automatic)
            .navigationBarItems(leading: refreshToFetchCourseButton,
                                trailing: addButton.foregroundColor(.blue))
        }
        .onAppear(perform: viewModel.getchCourse)
    }
}

extension TeacherCourseView {
    
    init() {
        self.init(viewModel: TeacherCourseViewModel(teachNumber: "1001"))
    }
    
    func loadLocalData() {
        
    }
    
    func onMoveCourse(source: IndexSet, destination: Int) {
        viewModel.moveCourse(from: source, to: destination)
    }
    
    func onDeleteCourse(at indexSet: IndexSet) {
        viewModel.deleteCourse(indexSet)
    }
    
    var refreshToFetchCourseButton: some View {
        Button(action: viewModel.getchCourse) {
            Image(systemName: "arrow.clockwise.circle.fill")
                .foregroundColor(.pink)
        }
    }
    
    var addButton: some View {
        Button(action: { self.isShowCourseSheet.toggle() }) {
            Image(systemName: "plus.square.fill")
                .foregroundColor(.pink)
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
