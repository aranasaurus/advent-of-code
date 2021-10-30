//
//  EntryView.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

struct EntryView<Content>: View where Content: View {
    let year: Int
    let day: Int
    let answerString: () -> String
    let runAction: @Sendable () async -> Void
    let content: () -> Content

    @State private var showPopover = false

    var body: some View {
        NavigationLink("Day \(day)") {
            TabView {
                AdventOfCodeWebView(year: year, day: day)
                    .frame(minWidth: 860)
                    .tabItem({ Text("adventofcode.com") })

                content()
                    .tabItem({ Text("Entry") })
                    .task(runAction)
                    .onTapGesture {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(self.answerString(), forType: .string)
                        self.showPopover = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.showPopover = false })
                    }
                    .popover(isPresented: $showPopover) {
                        Text("Copied!")
                            .padding(8)
                    }
            }.padding()
        }
    }
}
