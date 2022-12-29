//
//  DamusSearchView.swift
//  damus
//
//  Created by user232838 on 12/29/22.
//

import SwiftUI

struct DamusSearchView: View {
    var body: some View {
        ZStack {
            Color("ContentBackground")
            Text("TODO: Search")
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                Image("ic-profile")
            }
            ToolbarItem (placement: .principal) {
                Text("Search")
            }
            ToolbarItem (placement: .navigationBarTrailing) {
                Image("ic-settings")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DamusSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DamusSearchView()
    }
}
