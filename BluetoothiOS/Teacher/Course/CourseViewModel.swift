//
//  TeacherCourseViewModel.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/26.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class TeacherCourseViewModel: ObservableObject {
    
    @Published var classList: Array<String> = []
    @Published var courseList: Array<CourseResponseData>
    @Published var form: Course
    @Published var teacherNumber: String
    @Published var message: String = ""
    
    init(teachNumber: String) {
        self.courseList = Array<CourseResponseData>()
        self.form = Course()
        self.teacherNumber = teachNumber
        self.classList = []
        self.loadRemoteClass()
    }
    
    //    MARK: - Access to the model
    func sendStudentStringToBLE(of studentString: String) {
        if let connectedCharacteristic = BLEManager.shared.connectedWriteCharacteristic {
            BLEManager.shared.sendDataToDevice(sendString: studentString, connectedCharacteristic)
        } else {
            print("没有连接到蓝牙 Write Characteristic，发送数据失败")
        }
    }
    
    //    MARK: - Course Intents
    func getchCourse() -> Void {
        APIClient.teacherGetCourse(username: teacherNumber) { (result) in
            switch result {
            case .failure(let error):
                self.message = error.localizedDescription
                print(error)
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

    func loadRemoteClass() {
        APIClient.teacherGetClass { (result) in
            switch result {
            case .failure(let error):
                print(error)
                self.message = error.localizedDescription
            case .success(let classResponse):
                self.message = classResponse.msg
                self.classList = classResponse.data
            }
        }
    }
    
//
//    //    MARK: - Students Intents
//    func addStudent(_ courseIndex: Int, _ student: Student) {
//        courseList[courseIndex].students.append(student)
//    }
//
//    func deleteStudent(_ courseIndex: Int, studentIndex: Int) {
//        courseList[courseIndex].students.remove(at: studentIndex)
//    }
//
//    func moveStudent(_ courseIndex: Int,from source: IndexSet, to destination: Int) {
//        courseList[courseIndex].students.move(fromOffsets: source, toOffset: destination)
//    }
}

extension TeacherCourseViewModel {
    func clearCourseForm() {
        self.form = Course()
        self.form.name = ""
        self.form.classList = []
        self.form.roomOf = ""
    }
}
