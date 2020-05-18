//
//  CommonViewComponent.swift
//  SunnyRunnerBlueTooth
//
//  Created by LiaoGuoYin on 2020/5/14.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI


protocol DataProtocol {
    func refreshToGetData()
    func preserveToLocalData()
    func loadWithLocalData()
}

struct ImageAndTextView: View {
    @State var imageName: String
    @State var textName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(textName)
        }
    }
}

struct CustomTextFieldView: View {
    @State var varValue: String
    
    var varName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(varName)
                .font(.callout)
                .bold()
            TextField("1710030215", text: self.$varValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
    
}

struct SectionTextAndImage: View {
    var name: String
    var image: String
    var body: some View {
        HStack {
            Image(systemName: image)
                .font(.headline)
            Text(name)
                .font(.system(.headline, design: .monospaced))
        }
        .padding()
        .foregroundColor(Color(.systemBlue))
    }
}
