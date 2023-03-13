//
//  ComposeViewApp.swift
//  ComposeView
//
//  Created by Gabriel Rodrigues on 20/02/23.
//

import SwiftUI

@main
struct ComposeViewApp: App {
    
    var body: some Scene {
        WindowGroup {
            Coordinator.createView()
        }
    }
}
