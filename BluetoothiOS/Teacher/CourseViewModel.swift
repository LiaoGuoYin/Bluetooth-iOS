//
//  TeacherCourseViewModel.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/26.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

class TeacherCourseViewModel: ObservableObject {
    @Published var courseList: Array<Course>
    
    init() {
        self.courseList = Array<Course>()
    }
    
    //    MARK: - Access to the model
    
    //    MARK: - Course Intents
    func addCourse(_ course: Course) {
        courseList.append(course)
    }
    
    func deleteCourse(_ courseIndex: Int) {
        courseList.remove(at: courseIndex)
    }
    
    func moveCourse(from source: IndexSet, to destination: Int) {
        courseList.move(fromOffsets: source, toOffset: destination)
    }
    
    //    MARK: - Students Intents
    func addStudent(_ courseIndex: Int, _ student: Student) {
        courseList[courseIndex].students.append(student)
    }
    
    func deleteStudent(_ courseIndex: Int, studentIndex: Int) {
        courseList[courseIndex].students.remove(at: studentIndex)
    }
    
    func moveStudent(_ courseIndex: Int,from source: IndexSet, to destination: Int) {
        courseList[courseIndex].students.move(fromOffsets: source, toOffset: destination)
    }
}

