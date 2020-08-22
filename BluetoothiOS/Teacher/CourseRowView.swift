//
//  TeacherCourseRowView.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct TeacherCourseRowView: View {
    @State var course: Course
    
    var body: some View {
        VStack(alignment:.leading,spacing: 16) {
            Text(course.name)
                .font(.headline)
            
            HStack {
                Text(course.classOf)
                Spacer()
                Text("\(course.capacity) 人")
            }
            .font(.subheadline)
        }
        .foregroundColor(.white)
        .padding()
        .background(Color(.systemBlue))
        .cornerRadius(8)
    }
    
}

extension TeacherCourseRowView {
    init() {
        self.init(course: Course())
    }
}

struct CourseRowView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherCourseRowView()
    }
}
