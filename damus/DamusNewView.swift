//
//  NewView.swift
//  damus
//
//  Created by user232838 on 12/29/22.
//

import SwiftUI

struct DamusNewView: View {
    var body: some View {
        TabView {
            NavigationView { DamusHomeView() }
            .tabItem {
                Image("ic-home")
            }
            NavigationView { DamusSearchView() }
                .tabItem {
                    Image("ic-search")
                }
            NavigationView { DamusHomeView() }
                .tabItem {
                    Image("ic-add")
                }
            NavigationView { DamusMessagesView() }
                .tabItem {
                    Image("ic-messages")
                }
            NavigationView { DamusNotificationsView() }
                .tabItem {
                    Image("ic-notifications")
                }
        }.background(Color("Background"))
        //.frame(width:maxWidth,height:91) // TODO: Fix height now working correctly.
    }
}

struct DamusNewView_Previews: PreviewProvider {
    static var previews: some View {
        DamusNewView()
    }
}
