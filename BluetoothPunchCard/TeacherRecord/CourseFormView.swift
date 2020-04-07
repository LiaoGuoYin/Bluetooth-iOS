//
//  CourseFormView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct CourseFormView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var iClass: String = ""
    @State var studentList: [String] = []
    
    var body: some View {
        Form {
            
            Section {
                HStack {
                    Text("班级：")
                    TextField("信管17-2", text: self.$iClass)
                }
            }
            Section {
                List(0 ..< 5) { item in
                    HStack {
                        Text("班级：")
                        TextField("信管17-2", text: self.$iClass)
                    }
                }
            }

            Button(action: {
                print("TODO post create")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Done")
                    Spacer()
                }
            }
        }
    }
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.left")
                    .opacity(self.presentationMode.wrappedValue.isPresented ? 1 : 0)
            }
        })
    }
    
    var addButton: some View {
        Button(action: {
            //            self.isShowClassListAddSheet.toggle()
        }) {
            ZStack(alignment: .trailing) {
                Rectangle()
                    .fill(Color.blue.opacity(0.0001))
                    .frame(width: 48, height: 48)
                Image(systemName: "plus.square.fill.on.square.fill")
            }
        }
    }
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        CourseFormView()
    }
}
