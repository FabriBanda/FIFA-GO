//
//  FanFestDetail.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 05/10/25.
//

import SwiftUI

struct FanFestDetail: View {
    let fanFest:FanFest
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var worldCupStore:WorldCupStore
    var body: some View {
        NavigationStack {
                
                VStack{
                    
                    Image(systemName: "party.popper.fill")
                        .foregroundStyle(Gradient(colors: [.red,.blue,.green]))
                        .font(.system(size: 50))
                    
                    Text("FIFA Fan Fest")
                        .font(.title)
                        .bold()
                    Text(fanFest.nombre)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 7)
                        .frame(width: 340,height: 200)
                        .overlay {
                            VStack{
                                HStack{
                                    Spacer()
                                    OpenToday()
                                }
                                Spacer()
                            }.padding(10)
                        }.padding(.top)
                    
                        ScrollView {
                        VStack(alignment: .leading){
                        
                            let eventosFanFest = worldCupStore.eventosEnFanFest(fanFest.id)
                            
                            ForEach(TipoEvento.allCases, id: \.self) { tipo in
                                if let eventos = eventosFanFest[tipo] {
                                    Section(header:
                                                Text(title(for: tipo))
                                        .font(.title2)
                                        .bold()
                                        .padding(.bottom, 4)
                                    ) {
                                        ForEach(eventos) { evento in
                                            EventoRow(evento: evento)
                                                .padding(.vertical, 6)
                                        }
                                    }
                                }
                            }
                            
                            
                        }.padding()
                    }
                    
                    HStack{
                        Button {
                            
                        } label: {
                            Text("Open Website")
                        }.buttonStyle(.glass)
                        
                        Button {
                            
                        } label: {
                            Text("Get Directions")
                        }.buttonStyle(.glass)
                    }
                    
                    
                    
                    Spacer()
                    }.padding()
                    .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.primary)
                                .font(.headline)
                        }
                        
                    }
                }
                    
                   
   
            }
        }
    func formatDateInterval(_ interval: DateInterval) -> String {
           let formatter = DateFormatter()
           formatter.timeStyle = .short
           return "\(formatter.string(from: interval.start)) - \(formatter.string(from: interval.end))"
       }
       
       func title(for tipo: TipoEvento) -> String {
           switch tipo {
           case .liveEvents: return "Live Events"
           case .activities: return "Activities"
           case .liveBroadcasts: return "Live Broadcasts"
           }
       }
    }


struct EventoRow: View {
    let evento: Evento
    @EnvironmentObject var worldCupStore: WorldCupStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !evento.tipo.rawValue.contains("liveBroadcasts") {
                Text(evento.titulo)
                    .font(.headline)
            }
          
            if let equipos = worldCupStore.equiposParaBroadcast(eventID: evento.id) {
                MatchView(showAllHorizontal: true, partido: Partido(id: "ss", equipo1: Equipo(id: equipos.0.id, nombre: equipos.0.nombre, bandera: equipos.0.bandera), equipo2: Equipo(id: equipos.1.id, nombre: equipos.1.nombre, bandera: equipos.1.bandera), inicio: Date.now, estadioID: "KK"))
            }
            Text(timeString(from: evento.inicio))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
struct OpenToday:View {
    var body: some View {
        VStack{
            Text("OPEN TODAY")
                .font(.title3)
            Text("10:00 AM - 10:00 PM")
                .font(.headline)
        }
        .bold()
        .foregroundStyle(Color.openTodayFont)
        .padding()
        .background(Color.openTodayBackground,in:RoundedRectangle(cornerRadius: 20))
    }
}


struct TextFanFest:View {
    let text:String
    var body: some View {
        Text(text)
            .font(.title3)
            .bold()
            .foregroundStyle(.primary)
            .padding(.top)
    }
}

#Preview {
    let fanfest = WorldCupStore()
    FanFestDetail(fanFest: fanfest.fanfests[0]).environmentObject(fanfest)
}
