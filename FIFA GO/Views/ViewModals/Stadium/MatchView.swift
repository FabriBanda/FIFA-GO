//
//  MatchView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 10/10/25.
//


import SwiftUI
import MapKit

struct MatchView: View {
    

    let equipo1: Equipo
    let equipo2: Equipo
    let hora:String
    let showHorizontal:Bool
    
    @Environment(\.dynamicTypeSize) var dynamicText
   
    var body: some View {
        VStack {
            
            let hour =  Text(hora)
                .font(.subheadline)
                .bold()
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
            
            if dynamicText.showExpandView{
            
                HStack {
                    Spacer()
                    VStack(alignment: .center,spacing: 8){
                        
                        
                        TextFanFest(text:equipo1.bandera + equipo1.nombre)
                        TextFanFest(text:equipo2.bandera + equipo2.nombre)
                        hour
                        
                      
                    }
                    Spacer()
                }.padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }else{
                
                
                if showHorizontal{
                    HStack{
                        
                        
                        TextFanFest(text:equipo1.bandera + equipo1.nombre + " vs " + equipo2.nombre + equipo2.bandera)
                            
                        
                        Spacer()
                        hour
                        
                    }
                }else{
                    VStack(alignment: .center){
                        HStack{
                            Spacer()
                            TextFanFest(text:equipo1.bandera + equipo1.nombre)
                            Spacer()
                            TextFanFest(text:equipo2.nombre + equipo2.bandera)
                            Spacer()
                        }
                        
                        hour
                    }
                }
              
            }
        }.foregroundStyle(.primary)
    }
}
