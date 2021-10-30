//
//  ContentView.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Day1().entry()
        }
    }
}

extension View where Self: EntryViewable {
    @ViewBuilder
    func entry() -> some View {
        NavigationLink("Day \(day)") {
            TabView {
                tabItem({ Text("Entry") })

                AdventOfCodeWebView(year: year, day: day)
                    .frame(minWidth: 844)
                    .tabItem({ Text("Description") })
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
