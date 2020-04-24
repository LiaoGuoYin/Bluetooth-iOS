//
//  TeacherAttendanceView.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/4/7.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI
import WebKit

struct TeacherAttendanceView: View {
    //    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var isShowClassListAddSheet: Bool = false
    @State private var searchText: String = ""
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: self.$searchText)
                
                List {
                    Section(header: Text("课程列表")) {
                        NavigationLink(destination: WebView(request: URLRequest(url: URL(string: "https://liaoguoyin.com")!))) {
                            CourseRowBlockView()
                        }
                        
                        NavigationLink(destination: CoursePunchCardHistoryView()) {
                            CourseRowBlockView()
                        }
                        
                        NavigationLink(destination: CoursePunchCardHistoryView()) {
                            CourseRowBlockView()
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .sheet(isPresented: self.$isShowClassListAddSheet, content: { CourseFormView() })
                .navigationBarTitle(Text("考勤管理"), displayMode: .inline)
                .navigationBarItems(trailing: addButton)
            }
        }
    }
    
    var addButton: some View {
        Button(action: {
            self.isShowClassListAddSheet.toggle()
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

struct TeacherAttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherAttendanceView()
    }
}

struct SearchBar: UIViewRepresentable {
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    
}


struct WebView: UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        uiView.load(request)
    }
}
