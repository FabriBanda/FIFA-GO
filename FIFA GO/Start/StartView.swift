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

            VStack(alignment: .center,spacing: 20){
                 
                if startAnimation{
                     
                Image(colorScheme == .dark ? "worldcupDark":"worldcup") 
                    .resizable()
                    .scaledToFit()
                    .transition(.scale)
                
                    Text(String(localized: "app.title", defaultValue: "FIFA GO"))
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .foregroundStyle(.primary)
                        .bold()
                        .transition(.scale)
                        .accessibilityLabel(String(localized: "app.title", defaultValue: "FIFA GO"))
                        .accessibilityAddTraits(.isHeader)
                         
              
                Text(String(localized: "app.description", defaultValue: "Your all-in-one guide to the FIFA World Cup 2026. Explore stadiums, matches, accessible routes, and entrances for everyone"))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
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
