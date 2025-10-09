//
//  StartView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 08/10/25.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var worldCup:WorldCupStore
    @State private var startAnimation : Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack(alignment: .center,spacing: 20){
                
                if startAnimation{
                    
                Image(colorScheme == .dark ? "worldcupDark":"worldcup")
                    .resizable()
                    .scaledToFit()
                    .transition(.scale)
                }
                    Text("FIFA GO")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .foregroundStyle(.primary)   
                        .bold()
                        
              
                Text("Your all-in-one guide to the FIFA World Cup 2026. Explore stadiums, matches, accessible routes, and entrances for everyone")
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
                    .opacity(startAnimation ? 1:0)
                
                if startAnimation{
                    
                    NavigationLink(destination:EmptyView()){
                        
                            Image(systemName: "arrowshape.forward.circle")
                                .font(.system(size: 60))
                                .foregroundStyle(Color(.label))
                              
                    }  .transition(.offset(x:-400,y:0))
                  
                }
                
                
            }.onAppear{
                withAnimation(.smooth(duration:1).delay(0.2)){
                    startAnimation = true
                }
            }
        }
        
        
    }
}

#Preview {
    StartView().environmentObject(WorldCupStore())
}
