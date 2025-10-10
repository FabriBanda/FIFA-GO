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
                    
                    if dynamicType.showExpandView{
                    
                        HStack {
                            Spacer()
                            VStack(alignment: .center){
                                
                                
                                TextFanFest(text:equipo1.bandera + equipo1.nombre)
                                TextFanFest(text:equipo2.bandera + equipo2.nombre)
                                
                                
                                hora
                            }
                            Spacer()
                        }
                    }else{
                        HStack{
                            
                            
                            
                            TextFanFest(text:equipo1.bandera + equipo1.nombre + "  vs")
                            TextFanFest(text:equipo2.nombre + equipo2.bandera)
                            
                            Spacer()
                            hora
                            
                            
                        }
                    }
                }
              
            }
            
            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
            
    }
}

extension DynamicTypeSize {
    var showExpandView:Bool{
        switch self {
        case .accessibility1,.accessibility2,.accessibility3,.accessibility4,.accessibility5:
            return true
            
        default:
            return false
        }
    }
}
