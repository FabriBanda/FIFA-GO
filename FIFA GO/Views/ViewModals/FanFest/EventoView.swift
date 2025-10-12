//
//  EventoView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 06/10/25.
//

import SwiftUI

struct EventoView: View {
    @EnvironmentObject var worldcupStore:WorldCupStore
    @Environment(\.dynamicTypeSize) var dynamicType
    let evento:Evento
    var body: some View {
        
        let hora = Text(worldcupStore.timeString(from: evento.inicio))
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
        VStack{
            Spacer()
            if !evento.tipo.rawValue.contains("liveBroadcasts") {
                if dynamicType.showExpandView{
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .center){
                            TextFanFest(text: evento.titulo)
                            hora
                        }
                        Spacer()
                    }
                }else{
                    HStack{
                        
                        TextFanFest(text: evento.titulo)
                        
                        Spacer()
                        hora
                        
                        
                    }
                }
                
                
            }else{
                if let equipos = worldcupStore.equiposParaBroadcast(eventID: evento.id){
                    
                    let equipo1 = equipos.0
                    let equipo2 = equipos.1
                    
                    MatchView(equipo1: equipo1, equipo2: equipo2, hora: worldcupStore.timeString(from: evento.inicio),showHorizontal: true)
                }
              
            }
            
            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
            
    }
}



