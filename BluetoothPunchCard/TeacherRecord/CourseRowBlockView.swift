//
//  CourseRowBlockView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct CourseRowBlockView: View {
    @State var courseName: String = "Python 程序设计"
    @State var className: String = "信管17-2"
    @State var classPeopleCount: Int = 57
    
    var body: some View {
        VStack(alignment:.leading,spacing: 16) {
            Text(courseName)
                .font(.headline)
            
            HStack {
                Text(className)
                Spacer()
                Text("\(self.classPeopleCount) 人")
            }
            .font(.subheadline)
        }
        .foregroundColor(.white)
        .padding()
        .background(Color(.systemBlue))
        .cornerRadius(8)
    }
}

struct ClassListRow_Previews: PreviewProvider {
    static var previews: some View {
        CourseRowBlockView()
    }
}
