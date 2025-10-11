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

            
        ScrollView { 
            VStack(spacing: 13) {
                Spacer()
                
                Text(LocalizedStringKey("Your Guide to\nFIFA GO"))
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()
                
                ItemTutorial(title:LocalizedStringKey("Live Translation"), description: LocalizedStringKey("Point your camera at any text and get an instant translation into your preferred language"), nameImage: "translate", backgroundColor: .purple)
                
                ItemTutorial(title:LocalizedStringKey("World Cup Stadiums"), description:LocalizedStringKey("Browse all 2026 World Cup stadiums. Filter by country or name, and tap to see each on the map"), nameImage: "sportscourt.fill", backgroundColor: .blue)
                
                ItemTutorial(title:LocalizedStringKey("Fan Fests"), description:LocalizedStringKey("Browse World Cup Fan Fests. Tap any one to see its exact location on the map and find your way there"), nameImage: "party.popper.fill", backgroundColor: .cyan)
                
                ItemTutorial(title:LocalizedStringKey("Stadium Marker"), description:LocalizedStringKey("Explore 2026 stadiums by country or name, and view any location on the map"), nameImage: "soccerball.inverse", backgroundColor: Color.colorGuadalajara)
                
                ItemTutorial(title: LocalizedStringKey("Fan Fest Marker"), description: LocalizedStringKey("Tap a Fan Fest pin to see Look Around, live screenings, and events"), nameImage: "party.popper.fill", backgroundColor: Color.colorMonterrey)
                
                ItemTutorial(title:LocalizedStringKey("My Location"), description: LocalizedStringKey("Tap to center the map on your current location"), nameImage: "location.circle.fill", backgroundColor: .black)
                
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
}


#Preview {
    TutorialView().environmentObject(WorldCupStore())
}
