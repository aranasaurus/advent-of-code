//
//  EntryView.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

struct EntryView: View {
    @ObservedObject var entry: Entry
    @State var showPopover = false
    @State var showWeb = false

    var body: some View {
        HStack {
            Text("Day \(entry.day) Part \(entry.part):")

            Spacer()

            Text(entry.answer ?? "Not run yet")
                .font(.system(.body).monospaced())
                .onTapGesture(perform: copyAnswerToClipboard)
                .popover(isPresented: $showPopover) {
                    Text("Copied!")
                        .padding(8)
                }
            
            Button(action: { Task(operation: entry.run) }) {
                Image(systemName: "play.fill")
            }

            Button(action: { self.showWeb = true }) {
                Image(systemName: "scroll.fill")
            }
        }
        .padding()
        .frame(alignment: .leading)
        .buttonStyle(.borderless)
        .popover(isPresented: $showWeb) {
            AdventOfCodeWebView(year: entry.year, day: entry.day)
                .frame(minWidth: 860, idealWidth: 1024, idealHeight: 720)
        }
    }

    private func copyAnswerToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(entry.answer ?? "Not run yet", forType: .string)

        showPopover = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showPopover = false
        }
    }
}
