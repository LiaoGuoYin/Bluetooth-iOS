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
        HStack(alignment: .firstTextBaseline) {
            Text(course.name)
                .font(.headline)
            Spacer()
            Text(course.classList)
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
