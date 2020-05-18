//
//  NoticeNewView.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/4/18.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct NoticeNewView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                
                //                GeometryReader { gr in
                //                    Image("map")
                //                        .resizable()
                //                        .aspectRatio(contentMode: .fill)
                //                        .blur(radius: 1)
                //                        .scaleEffect(1.6)
                //                        .opacity(0.4)
                //                        .offset(y: -gr.frame(in: .global).minY / 3)
                ////                        .offset(y: gr.f)
                //                }
                
                VStack(spacing: 20) {
                    Tile(imageName: "Arches", tileLabel: "Arches")
                    Tile(imageName: "Canyonlands", tileLabel: "Canyonlands")
                    Tile(imageName: "BryceCanyon", tileLabel: "Bryce Canyon")
                    Tile(imageName: "GoblinValley", tileLabel: "Goblin Valley")
                    Tile(imageName: "Zion", tileLabel: "Zion")
                }
                .padding(.horizontal)
                .padding(.top, 310)
                
                
                // Top Layer (Header)
                GeometryReader { gr in
                    VStack {
                        Image("Utah")
                            .resizable()
                            .scaledToFill()
                            .frame(height: self.calculateHeight(minHeight: 120,
                                                                maxHeight: 300,
                                                                yOffset: gr.frame(in: .global).origin.y))
                            .shadow(radius: self.calculateHeight(minHeight: 120,
                                                                 maxHeight: 300,
                                                                 yOffset: gr.frame(in: .global).origin.y) < 140 ? 8 : 0)
                        //                            .overlay(
                        //                                Text("UTAH")
                        //                                    .font(.system(size: 70, weight: .black))
                        //                                    .foregroundColor(.white)
                        //                                    .opacity(0.8)
                        //                        )
                        
                        Spacer() // Push header to top
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
    
    func calculateHeight(minHeight: CGFloat, maxHeight: CGFloat, yOffset: CGFloat) -> CGFloat {
        // If scrolling up, yOffset will be a negative number
        if maxHeight + yOffset < minHeight {
            // SCROLLING UP
            // Never go smaller than our minimum height
            return minHeight
        }
        else if maxHeight + yOffset > maxHeight {
            // SCROLLING DOWN PAST MAX HEIGHT
            return maxHeight + (yOffset * 0.5) // Lessen the offset
        }
        
        // Return an offset that is between the min and max heights
        return maxHeight + yOffset
    }
}


struct NoticeNewView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeNewView().previewDevice("iPhone Xs Max")
    }
}

struct Tile: View {
    var imageName = ""
    var tileLabel = ""
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 160, alignment: .bottom)
            //            .frame(height: UIScreen.main.bounds.width - 100, alignment: .bottom)
            .cornerRadius(18)
            .shadow(color: .gray, radius: 10, x: 0, y: 5)
            .overlay(
                VStack {
                    Spacer()
                    Text(tileLabel)
                        .foregroundColor(.white)
                        .opacity(0.85)
                        .font(.system(size: 30, weight: .black))
                        .padding(.bottom, 24)
            })
    }
}
