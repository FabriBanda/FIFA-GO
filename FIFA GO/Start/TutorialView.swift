//
//  TutorialView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 08/10/25.
//


import SwiftUI

struct TutorialView: View {

    @State private var showMap = false

    @EnvironmentObject var worldCupStore: WorldCupStore
    @StateObject var login = Login()
    
    var body: some View {

            
                VStack(spacing: 13) {
                    Spacer()
                    
                    Text("Your Guide to\nFIFA GO")
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .bold()
                    
                    ItemTutorial(title: "Live Translation", description: "Point your camera at any text and get an instant translation into your preferred language.", nameImage: "translate", backgroundColor: .purple)
                    
                    ItemTutorial(title: "World Cup Stadiums", description: "Browse all 2026 World Cup stadiums. Filter by country or name, and tap to see each on the map.", nameImage: "sportscourt.fill", backgroundColor: .blue)
                    
                    ItemTutorial(title: "Fan Fests", description: "Browse World Cup Fan Fests. Tap any one to see its exact location on the map and find your way there.", nameImage: "party.popper.fill", backgroundColor: .cyan)
                    
                    ItemTutorial(title: "Stadium Marker", description: "Explore 2026 stadiums by country or name, and view any location on the map.", nameImage: "soccerball.inverse", backgroundColor: Color.colorGuadalajara)
                    
                    ItemTutorial(title: "Fan fest Marker", description: "Tap a Fan Fest pin to see Look Around, live screenings, and events.", nameImage: "party.popper.fill", backgroundColor: Color.colorMonterrey)
                    
                    ItemTutorial(title: "My Location", description: "Tap to center the map on your current location", nameImage: "location.circle.fill", backgroundColor: .black)
                    
                    Button {
                        showMap = true
                        login.hasSeenMapView = true
                    } label: {
                        ContinueButton()
                    }
                    .padding(.vertical)
                    .buttonStyle(.plain)
                    .tint(.blue)
                    
               
                }
                .padding(.horizontal)
            
               .fullScreenCover(isPresented: $showMap) {
                MapView()
                    .environmentObject(worldCupStore)
            }
  
    }
}


#Preview {
    TutorialView().environmentObject(WorldCupStore())
}
