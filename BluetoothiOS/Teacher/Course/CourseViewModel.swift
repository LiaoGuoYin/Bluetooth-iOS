//
//  TeacherCourseViewModel.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/26.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class TeacherCourseViewModel: ObservableObject {
    
    @Published var courseList: Array<CourseResponseData>
    @Published var form: Course
    @Published var teacherNumber: String = "0001" // FOR demo TODO
    @Published var message: String = ""
    
    init() {
        self.courseList = Array<CourseResponseData>()
        self.form = Course()
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
                print(courseResponse)
            }
        }
    }
    
//    func addCourse(_ course: Course) {
//        courseList.append(course)
//    }

    func deleteCourse(_ courseIndexSet: IndexSet) {
        courseList.remove(atOffsets: courseIndexSet)
    }

    func moveCourse(from source: IndexSet, to destination: Int) {
        courseList.move(fromOffsets: source, toOffset: destination)
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
        self.form.classOf = ""
    }
}
