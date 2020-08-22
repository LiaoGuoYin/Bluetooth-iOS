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
    
    //    MARK: - Intents
    func add(_ course: Course) {
        courseList.append(course)
    }
    
    func delete(_ courseIndex: Int) {
        courseList.remove(at: courseIndex)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        courseList.move(fromOffsets: source, toOffset: destination)
    }
}

