//
//  SetApp.swift
//  Set
//
//  Created by Nathan Henrie on 20210617.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: SetGame())
        }
    }
}
