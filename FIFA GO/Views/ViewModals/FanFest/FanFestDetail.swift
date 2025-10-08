//
//  FanFestDetail.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 05/10/25.
//

import SwiftUI
import MapKit

struct FanFestDetail: View {
    let fanFest:FanFest
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var worldCupStore:WorldCupStore
    @State private var isLoadingScene = false
    @State private var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        
                
        NavigationStack {
            VStack{
                
                VStack(spacing: 0){
                    
                    Image("boston")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250,height: 180)
                        .padding(.bottom)
                    Group {
                        if let _ = lookAroundScene {
                            LookAroundPreview(scene: $lookAroundScene)
                                .frame(height: 200) // IMPORTANTE: altura fija
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.bottom, 8)
                        } else if isLoadingScene {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .frame(height: 200)
                                ProgressView("Cargando vista previa…")
                            }
                            .padding(.bottom, 8)
                        } else {
                            Map(initialPosition: .region(.init(
                                center: fanFest.ubicacion.coordinate,
                                latitudinalMeters: 1200,
                                longitudinalMeters: 1200
                            ))) {
                                Annotation(fanFest.nombre, coordinate: fanFest.ubicacion.coordinate) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)
                                        .foregroundStyle(.red)
                                }
                            }
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            
                        }
                        
                    }
                    .overlay{
                        VStack{
                            HStack{
                                Spacer()
                              //  OpenToday()
                                    .padding(5)
                            }
                            
                            Spacer()
                        }
                    } .padding(.horizontal)
                    Spacer()
                }
                
                ScrollView {
                    VStack(alignment: .leading){
                        
                        let eventosFanFest = worldCupStore.eventosEnFanFest(fanFest.id)
                        
                        ForEach(TipoEvento.allCases, id: \.self) { tipo in
                            if let eventos = eventosFanFest[tipo] {
                                
                                Text(title(for: tipo))
                                    .font(.title2)
                                    .bold()
                                    .padding(.vertical, 4)
                                
                                ForEach(eventos) { evento in
                                    EventoView(evento: evento)
                                }
                                
                            }
                        }
                        
                    }
                }.padding(.horizontal)
                
                HStack{
                    
                    NavigationLink(destination: WebApi(url:fanFest.web)) {
                       
                           TextBottom(text: "Open Web")
                        
                    }
                    
                    TextBottom(text: "Get Directions")
                    
                    
                }
                
                Spacer()
            }
            .background(Gradient(colors: [getColorFanFest(name: fanFest.nombre),Color(.systemBackground)]))
            .onAppear { loadLookAround() }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
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
    
    private func loadLookAround() {
        isLoadingScene = true
        lookAroundScene = nil
        
        Task {
            
            let req = MKLookAroundSceneRequest(coordinate: fanFest.ubicacion.coordinate)
            let scene = try? await req.scene
            await MainActor.run {
                self.lookAroundScene = scene
                self.isLoadingScene = false
            }
        }
    }
    
    
    private func getColorFanFest(name:String)->Color{
        switch name{
        case "Seattle Center": return Color.colorBoston
        case "Macroplaza": return Color.colorMexico
        default: return Color.primary
        
        }
    }
    
    }

struct OpenToday:View {
    var body: some View {
        VStack{
            Text("OPEN TODAY")
                .font(.headline)
            Text("10:00 AM - 10:00 PM")
                .font(.caption)
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
    }
}

struct TextBottom:View {
    let text:String
    var body: some View {
        Text(text)
            .foregroundStyle(Color(.label))
            .padding()
            .glassEffect()
    }
}

#Preview {
    let fanfest = WorldCupStore()
    FanFestDetail(fanFest: fanfest.fanfests[0]).environmentObject(fanfest)
}
