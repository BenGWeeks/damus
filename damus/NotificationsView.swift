//
//  NotificationsView.swift
//  damus
//
//  Created by user232838 on 12/29/22.
//

import SwiftUI

struct NotificationsView: View {
    @Binding var events: [NostrEvent]
    let damus: DamusState
    let show_friend_icon: Bool
    let filter: (NostrEvent) -> Bool
    
    var body: some View {

    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
