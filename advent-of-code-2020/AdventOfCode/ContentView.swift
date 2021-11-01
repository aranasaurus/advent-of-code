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
            year2020
        }
        .frame(minWidth: 300)
        .padding()
    }

    @ViewBuilder private var year2020: some View {
        Text("2020")
            .font(.title)

        Divider()
            .padding(.horizontal)

        VStack {
            EntryView(entry: Entry2020Day01Part1())
            EntryView(entry: Entry2020Day01Part2())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 340)
    }
}
