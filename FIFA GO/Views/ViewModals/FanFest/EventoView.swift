//
//  EventoView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 06/10/25.
//

import SwiftUI

struct EventoView: View {
    @EnvironmentObject var worldcupStore:WorldCupStore
    let evento:Evento
    var body: some View {
        
        let hora = Text(worldcupStore.timeString(from: evento.inicio))
                    .font(.headline)
                    .foregroundStyle(.secondary)
        
        VStack{
            Spacer()
            if !evento.tipo.rawValue.contains("liveBroadcasts") {
                HStack{
                    TextFanFest(text: evento.titulo)
                    Spacer()
                    hora
                }
                
            }else{
                HStack{
                    
                    if let equipos = worldcupStore.equiposParaBroadcast(eventID: evento.id){
                        let equipo1 = equipos.0
                        let equipo2 = equipos.1
                        
                        TextFanFest(text:equipo1.bandera + equipo1.nombre + "  vs ")
                        TextFanFest(text:equipo2.nombre + equipo2.bandera)
                        
                        Spacer()
                        hora
                    }
                   
                }
            }
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
            
    }
}

