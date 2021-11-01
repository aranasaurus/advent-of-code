//
//  ContentView.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("2020")
                .font(.title)

            Divider()
                .padding(.horizontal)

            VStack {
                EntryView(entry: Day1Part1Entry())
                EntryView(entry: Day1Part2Entry())
            }
        }
        .frame(minWidth: 300)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 340)
    }
}
