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
    @StateObject var worldCupStore = WorldCupStore()
    @StateObject var login = Login()

    init() {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if login.hasSeenMapView {
                    MapView()
                      
                } else {
                    StartView()
                       
                }
            }
            .environmentObject(login)
            .environmentObject(worldCupStore)
            
        }
    }
}
