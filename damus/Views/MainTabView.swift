//
//  MainTabView.swift
//  damus
//
//  Created by William Casarin on 2022-05-19.
//

import SwiftUI

enum Timeline: String, CustomStringConvertible {
    case home
    case notifications
    case search
    case dms
    
    var description: String {
        return self.rawValue
    }
}

func timeline_bit(_ timeline: Timeline) -> Int {
    switch timeline {
    case .home: return 1 << 0
    case .notifications: return 1 << 1
    case .search: return 1 << 2
    case .dms: return 1 << 3
    }
}

struct TabBar: View {
    @Binding var new_events: NewEventsBits
    @Binding var selected: Timeline?
    
    let action: (Timeline) -> ()
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                TabBarIcon(timeline: .home, img: "ic-home", selected: $selected, new_events: $new_events, action: action).keyboardShortcut("1")
                TabBarIcon(timeline: .search, img: "ic-search", selected: $selected, new_events: $new_events, action: action).keyboardShortcut("2")
                Image("ic-add")
                    .frame(width:60,height:60)
                TabBarIcon(timeline: .dms, img: "ic-messages", selected: $selected, new_events: $new_events, action: action).keyboardShortcut("3")
                TabBarIcon(timeline: .notifications, img: "ic-notifications", selected: $selected, new_events: $new_events, action: action).keyboardShortcut("4")
            }
        }
    }
}
    
struct TabBarIcon: View {
    let timeline: Timeline
    let img: String
    
    @Binding var selected: Timeline?
    @Binding var new_events: NewEventsBits
    
    let action: (Timeline) -> ()
    
    var body: some View {
        ZStack(alignment: .center) {
            Tab
            
            if new_events.is_set(timeline) {
                ZStack {
                    Circle()
                        //.size(CGSize(width: 8, height: 8))
                        .frame(width: 18, height: 18, alignment: .topTrailing)
                        .alignmentGuide(VerticalAlignment.center) { a in a.height + 2.0 }
                        .alignmentGuide(HorizontalAlignment.center) { a in a.width - 12.0 }
                        .foregroundColor(.accentColor)
                    Text(String(new_events.bits))
                }
            }
        }
    }
    
    var Tab: some View {
        Button(action: {
            action(timeline)
            new_events = NewEventsBits(prev: new_events, unsetting: timeline)
        }) {
            //Label("", systemImage: selected == timeline ? "\(img).fill" : img)
            if selected == timeline {
                Image(img)
                    .foregroundColor(.accentColor)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity, minHeight: 30.0)
            }
            else {
                Image(img)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity, minHeight: 30.0)
            }
        }
        .foregroundColor(selected != timeline ? .gray : .primary)
    }
}

/*
struct TabBar_Previews: PreviewProvider {
    @State var new_events: NewEventsBits
    @State var selected: Timeline?
    let action: (Timeline) -> ()
    
    static var previews: some View {
        TabBar(new_events: $new_events, selected: nil, action: nil)
    }
}
*/
