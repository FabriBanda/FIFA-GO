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
    var body: some Scene {
        WindowGroup {
            MapView()
                .task {
                    try? Tips.configure([
                        // cuando queremos que se vea el tip , en este caso de forma inmediata para que solo se muestre cuando el usuario se mete a la app por primera vez
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                       
                    ])
                }
        }
    }
}
