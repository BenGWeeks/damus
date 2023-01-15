//
//  TaggingView.swift
//  damus
//
//  Created by user232838 on 1/15/23.
//

import SwiftUI

struct TaggingView: UIViewRepresentable {
    func makeUIView(context: Context) -> Tagging {
        Tagging()
    }
    
    func updateUIView(_ uiView: Tagging, context: Context) {
        //uiView.
    }
    
    typealias UIViewType = Tagging
    /*var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }*/
}

struct TaggingView_Previews: PreviewProvider {
    static var previews: some View {
        TaggingView()
    }
}
