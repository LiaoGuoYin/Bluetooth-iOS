//
//  TeacherCourseRowView.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TeacherCourseRowView: View {
    @Binding var course: CourseResponseData
    
    var body: some View {
        HStack {
            VStack(alignment:.leading, spacing: 16) {
                Text(course.name)
                    .font(.headline)
                Text("授课班级：\(course.classList.count) 个")
            }
            Spacer()
            Text(course.roomOf)
                .font(.subheadline)
        }
        .cornerRadius(6)
    }
}

struct CourseRowView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherCourseRowView(course: .constant(CourseResponseData()))
    }
}
