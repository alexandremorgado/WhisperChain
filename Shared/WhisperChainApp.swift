//
//  WhisperChainApp.swift
//  Shared
//
//  Created by Alexandre Morgado on 21/12/21.
//

import SwiftUI

@main
struct WhisperChainApp: App {
    var body: some Scene {
        WindowGroup {
            WhispersListView()
                #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
                #endif
        }
    }
}
