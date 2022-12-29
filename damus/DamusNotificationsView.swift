//
//  DamusNotificationsView.swift
//  damus
//
//  Created by user232838 on 12/29/22.
//

import SwiftUI

struct DamusNotificationsView: View {
    var body: some View {
        ZStack {
            Color("ContentBackground")
            Text("TODO: Notifications")
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                Image("ic-profile")
            }
            ToolbarItem (placement: .principal) {
                Text("Notifications")
            }
            ToolbarItem (placement: .navigationBarTrailing) {
                Image("ic-settings")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DamusNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        DamusNotificationsView()
    }
}
