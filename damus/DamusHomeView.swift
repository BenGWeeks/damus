//
//  HomeView.swift
//  damus
//
//  Created by user232838 on 12/29/22.
//

import SwiftUI

struct DamusHomeView: View {
    var body: some View {
        ZStack {
            Color("ContentBackground")
            Text("TODO: Load home")
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                Image("ic-profile")
            }
            ToolbarItem (placement: .principal) {
                Menu("All relays") {
                    Button("wss://no.str.cr", action: filterRelays)
                    Button("wss://nostr.robotechy.com", action: filterRelays)
                }
                // TODO: Make this text bold
                // TODO: Add a down chevron
                // TODO: Update selection to highlight what you have chosen
                .cornerRadius(24) // TODO: Fix corner radius of the selection not working
                .background(Color.accentColor)
                .foregroundColor(Color.white)
            }
            ToolbarItem (placement: .navigationBarTrailing) {
                Image("ic-settings")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func filterRelays() { }
}

struct DamusHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DamusHomeView()
    }
}
