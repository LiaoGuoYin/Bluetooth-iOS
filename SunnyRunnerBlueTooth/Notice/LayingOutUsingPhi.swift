//
//  LayingOutUsingPhi.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/4/18.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct LayingOutUsingPhi: View {
    var body: some View {
        GeometryReader { gr in
            VStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: gr.size.height * 0.38)
                    .overlay(
                        Text("\(gr.size.height * 0.38)")
                )
                
                Rectangle()
                    .fill(Color.pink)
                    .overlay(
                        Text("\(gr.size.height * 0.62)")
                )
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct LayingOutUsingPhi_Previews: PreviewProvider {
    static var previews: some View {
        LayingOutUsingPhi()
    }
}
