////
////  NewCourseFormView.swift
////  BluetoothPunchCard
////
////  Created by LiaoGuoYin on 2020/6/28.
////  Copyright © 2020 LiaoGuoYin. All rights reserved.
////

import SwiftUI

struct NewCourseFormView: View {
    
    @ObservedObject var viewModel: TeacherCourseViewModel
    @State private var isShowAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var selectedClassSet: Set<String> = Set<String>()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("课程名称：")
                            .foregroundColor(.gray)
                        TextField("程序设计基础", text: $viewModel.form.name)
                            .font(.body)
                    }
                    HStack {
                        Text("上课教室：")
                            .foregroundColor(.gray)
                        TextField("尔雅221", text: $viewModel.form.roomOf)
                            .font(.body)
                    }
                }
                
                Section(
                    header: Text("开课班级"),
                    footer: Text("已选班级: \(selectedClassSet.count)")
                ) {
                    ForEach(viewModel.classList, id: \.self) { (eachClass) in
                        HStack {
                            Text(eachClass)
                            Spacer()
                            Image(systemName: (selectedClassSet.contains(eachClass) ? "checkmark.seal.fill" : "xmark.seal"))
                                .foregroundColor(selectedClassSet.contains(eachClass) ? Color.blue : Color.pink.opacity(0.8))
                        }
                        .onTapGesture(perform: {
                            if selectedClassSet.contains(eachClass) {
                                selectedClassSet.remove(eachClass)
                            } else {
                                selectedClassSet.update(with: eachClass)
                            }
                        })
                    }
                }
              
                Button(action: clearForm) {
                    HStack {
                        Spacer()
                        Text("重置")
                            .foregroundColor(Color(.systemRed))
                        Spacer()
                    }
                }
                
                Button(action: {submitForm(selectedClassSet)}) {
                    HStack {
                        Spacer()
                        Text("提交")
                        Spacer()
                    }
                }
            }
            .alert(isPresented: $isShowAlert, content: {
                Alert(title: Text(viewModel.message),
                      primaryButton: .destructive(Text("继续修改"), action: self.clearForm),
                      secondaryButton: .default(Text("完成"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                      })
            )})
            .disableAutocorrection(true)
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("新增课程"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {submitForm(selectedClassSet)}) { Text("提交")})
        }
    }
}

extension NewCourseFormView {
    
    var studentListSectionHeader: some View {
        HStack {
            Text("学生列表")
            Spacer()
            Button(action: {}) {
                Text("fresh")
                    .padding(6)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(5)
            }
        }
        .padding(3)
    }
    
    func clearForm() {
        viewModel.clearCourseForm()
    }
    
    func submitForm(_ selectedClassSet: Set<String>) {
        viewModel.form.classList = Array(selectedClassSet)
        
        guard viewModel.form.classList != [] else {
            viewModel.message = "请选择班级! 或者先让学生注册时填入班级"
            isShowAlert.toggle()
            return
        }
        
        viewModel.createCourse(viewModel.teacherNumber, viewModel.form)
        isShowAlert.toggle()
    }
}

struct NewCourseFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewCourseFormView(viewModel: TeacherCourseViewModel(teachNumber: "0001"))
    }
}
