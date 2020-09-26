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
    @State private var isShowAlert: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("课程列表") ) {
                    ForEach(0..<viewModel.courseList.count, id: \.self) { (index) in
                        VStack {
                            TeacherCourseRowView(course: $viewModel.courseList[index])
                            NavigationLink(
                                destination: CourseStudentView(viewModel: viewModel, classList: viewModel.courseList[index].classList),
                                label: { HStack {
                                    ForEach(viewModel.courseList[index].classList, id: \.self) { (singleClass) in
                                        Text(singleClass)
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color.pink.opacity(0.9))
                                            .cornerRadius(6)
                                            .font(.caption)
                                    }
                                }
                                })
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: onDeleteCourse)
                }
            }
            .sheet(isPresented: $isShowCourseSheet) {
                NewCourseFormView(viewModel: self.viewModel)
                    .onDisappear(perform: viewModel.getchCourse)
            }
            .navigationBarTitle(Text("考勤管理"), displayMode: .automatic)
            .navigationBarItems(leading: refreshToFetchCourseButton,
                                trailing: addButton.foregroundColor(.blue))
            .alert(isPresented: $isShowAlert, content: {
                Alert(title: Text(viewModel.message), dismissButton: .default(Text("OK")))
            })
        }
        .onAppear(perform: viewModel.getchCourse)
    }
}

extension TeacherCourseView {
    
    init() {
        self.init(viewModel: TeacherCourseViewModel(teachNumber: "0001"))
    }
    
    func loadLocalData() {
        
    }
    
    func onDeleteCourse(at offsets: IndexSet) -> Void {
        viewModel.deleteCourse(offsets)
        self.isShowAlert.toggle()
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
