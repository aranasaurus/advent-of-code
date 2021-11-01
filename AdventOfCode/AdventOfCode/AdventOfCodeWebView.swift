//
//  AdventOfCodeWebView.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI
import WebKit

struct AdventOfCodeWebView: NSViewRepresentable {
    let year: Int
    let day: Int

    var url: URL {
        URL(string: "https://adventofcode.com/\(year)/day/\(day)")!
    }

    private let webView: WKWebView = WKWebView()

    public func makeNSView(context: NSViewRepresentableContext<AdventOfCodeWebView>) -> WKWebView {
        webView.load(URLRequest(url: url))
        return webView
    }

    public func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<AdventOfCodeWebView>) { }
}
