//
//  StartView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 08/10/25.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var worldCupStore: WorldCupStore
    @State private var startAnimation : Bool = false
    @State private var showTutorial : Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            if startAnimation {
                
                Image(colorScheme == .dark ? "worldcupDark" : "worldcup")
                    .resizable()
                    .scaledToFit()
                    .transition(.scale)
                
<<<<<<< HEAD
                    Text(String(localized: "app.title", defaultValue: "FIFA GO"))
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .foregroundStyle(.primary)
                        .bold()
                        .transition(.scale)
                        .accessibilityLabel(String(localized: "app.title", defaultValue: "FIFA GO"))
                        .accessibilityAddTraits(.isHeader)
                         
              
                Text(String(localized: "app.description", defaultValue: "Your all-in-one guide to the FIFA World Cup 2026. Explore stadiums, matches, accessible routes, and entrances for everyone"))
=======
                Text("FIFA GO")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .foregroundStyle(.primary)
                    .bold()
                    .transition(.scale)
                    .accessibilityLabel("FIFA GO")
                    .accessibilityAddTraits(.isHeader)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                
                Text(LocalizedStringKey("Your all-in-one guide to the FIFA World Cup 2026. Explore stadiums, matches, accessible routes, and entrances for everyone"))
>>>>>>> 3d946fe66c6a92d6f6b535d5ed2db5a59afa79f8
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
<<<<<<< HEAD
                    .opacity(startAnimation ? 1:0)
                    .accessibilityLabel(String(localized: "app.description", defaultValue: "Your all-in-one guide to the FIFA World Cup 2026. Explore stadiums, matches, accessible routes, and entrances for everyone"))
                
                    
                    Button{
                        showTutorial = true
                    }label:{
                            Image(systemName: "arrowshape.forward.circle")
                                .font(.system(size: 60)) 
                                .foregroundStyle(Color(.label))
                              
                    }
                    .transition(.offset(x:-400,y:0))
                    .accessibilityLabel(String(localized: "continue.tutorial", defaultValue: "Continue to tutorial"))
                    .accessibilityHint(String(localized: "continue.tutorial.hint", defaultValue: "Tap to start the app tutorial"))
                  
                }
                
                
            }.onAppear{
                withAnimation(.smooth(duration:1).delay(0.2)){
                    startAnimation = true
=======
                    .opacity(startAnimation ? 1 : 0)
                    .accessibilityLabel("Tu guía completa para la Copa Mundial FIFA 2026. Explora estadios, partidos, rutas accesibles y entradas para todos")
                    .lineLimit(5)
                    .minimumScaleFactor(0.6)
                
                Button {
                    showTutorial = true
                } label: {
                    Image(systemName: "arrowshape.forward.circle")
                        .font(.system(size: 60))
                        .foregroundStyle(Color(.label))
>>>>>>> 3d946fe66c6a92d6f6b535d5ed2db5a59afa79f8
                }
                .transition(.offset(x: -400, y: 0))
                .accessibilityLabel("Continuar al tutorial")
                .accessibilityHint("Toca para comenzar el tutorial de la aplicación")
            }
        }
        .onAppear {
            withAnimation(.smooth(duration: 1).delay(0.2)) {
                startAnimation = true
            }
        }
        .fullScreenCover(isPresented: $showTutorial) {
            TutorialView().environmentObject(worldCupStore)
        }
    }
}

#Preview {
    StartView().environmentObject(WorldCupStore())
}
