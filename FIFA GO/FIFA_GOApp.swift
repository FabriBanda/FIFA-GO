//
//  FIFA_GOApp.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 30/09/25.
//

import SwiftUI
import TipKit

@main
struct FIFA_GOApp: App {
    var worldCupStore = WorldCupStore()   // tu fuente de datos

    var body: some Scene {
        WindowGroup {
            MapView()
                .environmentObject(worldCupStore)      // se inyecta aquí
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
