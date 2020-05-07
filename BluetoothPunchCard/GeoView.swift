//
//  GeoView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/18.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct GeoView: View {
    var body: some View {
        ScrollView {
            Text("Getting the Origin")
                .font(.largeTitle)
                .padding()
            
            GeometryCard()
            GeometryCard()
            GeometryCard()
            GeometryCard()
            
        }
    }
}

struct GeoView_Previews: PreviewProvider {
    static var previews: some View {
        GeoView()
    }
}

struct GeometryCard: View {
    var body: some View {
        GeometryReader { gr in
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.pink)
                .overlay(
                    VStack {
                        Text("X: \(Int(gr.frame(in: CoordinateSpace.global).minX))")
                        
                        Text("Y: \(Int(gr.frame(in: CoordinateSpace.global).minY))")
                    }
                    .foregroundColor(Color.white)
            )
        }
        .padding()
        .frame(height: 400)
    }
}
