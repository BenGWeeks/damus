//
//  DamusMessagesView.swift
//  damus
//
//  Created by Ben Weeks on 12/29/22.
//

import SwiftUI

struct DamusMessagesView: View {
    var body: some View {
        ZStack {
            Color("ContentBackground")
            Text("TODO: Messages")
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                Image("ic-profile")
            }
            ToolbarItem (placement: .principal) {
                Text("Messages")
            }
            ToolbarItem (placement: .navigationBarTrailing) {
                Image("ic-settings")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DamusMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        DamusMessagesView()
    }
}
