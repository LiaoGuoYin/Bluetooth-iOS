//
//  BannerModifier.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/10/25.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    
    struct Data {
        var title: String
        var content: String
    }
    
    @Binding var data: Data
    @Binding var isShow: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShow {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(data.title)
                                .font(.headline)
                            Text(data.content)
                                .font(.subheadline)
                            Text("")
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 67/255, green: 154/255, blue: 215/255))
                        .cornerRadius(8)
                        .padding()
                        Spacer()
                    }
                    Spacer()
                }
                .animation(.easeInOut(duration: 0.3))
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture(perform: {
                    withAnimation {
                        isShow = false
                    }
                })
//                .onAppear(perform: {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        isShow = false
//                    }
//                })
            }
        }
    }
}

extension View {
    func banner(data: Binding<BannerModifier.Data>, isShow: Binding<Bool>) -> some View {
        return self.modifier(BannerModifier(data: data, isShow: isShow))
    }
}
struct BannerDemoView: View {
    @State var isShow: Bool = true
    @State var data: BannerModifier.Data = BannerModifier.Data(title: "DEMO", content: "This is description.")
    var body: some View {
        Text("Hello, World!")
            .banner(data: $data, isShow: $isShow)
            .onTapGesture(perform: {
                isShow = true
            })
    }
}
struct BannerModifier_Previews: PreviewProvider {
    static var previews: some View {
        BannerDemoView()
    }
}
