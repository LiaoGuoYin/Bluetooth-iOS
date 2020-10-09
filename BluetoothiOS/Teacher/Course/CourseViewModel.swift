//
//  TeacherCourseViewModel.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/26.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class TeacherCourseViewModel: ObservableObject {
    typealias Student = LoginResponseData
    
    @Published var classList: Array<String>
    @Published var studentList: Array<Student>
    @Published var courseList: Array<CourseResponseData>
    @Published var form: Course
    @Published var teacherNumber: String
    @Published var message: String = ""
    
    init(teachNumber: String) {
        self.teacherNumber = teachNumber
        self.form = Course()
        self.classList = []
        self.studentList = []
        self.courseList = []
        getCourse()
        initClass()
    }
    
    //    MARK: - Course Intents
    func getCourse() -> Void {
        APIClient.teacherGetCourse(username: teacherNumber) { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let courseResponse):
                self.message = courseResponse.msg
                self.courseList = courseResponse.data
            }
        }
    }
    
    func createCourse(_ teacherNumber: String, _ form: Course) {
        APIClient.teacherCreateCourse(teacherNumber, form) { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let response):
                self.message = response.msg
            }
        }
    }
    
    func deleteCourse(_ offsets: IndexSet) {
        if let actualOffset = offsets.first {
            APIClient.teacherDeleteCourse(teacherNumber, courseList[actualOffset].name) { (result) in
                switch result {
                case .failure(let error):
                    self.message = error.localizedDescription
                case .success(let response):
                    self.message = response.msg
                    self.courseList.remove(at: actualOffset)
                }
            }
        }
    }
    
    // MARK: - Class
    func initClass() {
        APIClient.teacherGetClass { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
            case .success(let classResponse):
                self.message = classResponse.msg
                self.classList = classResponse.data
                for each in self.classList {
                    self.loadClassStudentList(className: each) { (tmpStudentList) in
                        self.studentList.append(contentsOf: tmpStudentList)
                    }
                }
            }
        }
    }
    
    func loadClassStudentList(className: String, completion: @escaping (Array<Student>) -> ()) {
        APIClient.teacherGetStudentListByClassName(className: className) { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
                completion([])
            case .success(let studentListOfClass):
                completion(studentListOfClass.data)
            }
        }
    }
    
}

extension TeacherCourseViewModel {
    func clearCourseForm() {
        self.form = Course()
        self.form.name = ""
        self.form.classList = []
        self.form.roomOf = ""
    }
}
