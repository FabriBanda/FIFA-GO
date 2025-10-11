//
//  MapView.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 30/09/25.
//

import SwiftUI
import MapKit
import TipKit

struct MapView: View {
    
    @Namespace var namespace
    
    
    @State private var showStadiums:Bool = true
    
    @State private var showFanFests:Bool = false
    
    @State private var sheetPresentation = PresentationDetent.medium
    
    @State private var currentModal : ModalRoute?
    
    @State private var isExpanded : Bool = false
    
    @EnvironmentObject var worldCupStore:WorldCupStore
    
    let locationManager = CLLocationManager()
    
    var body: some View {
        Map(position:$worldCupStore.cameraPosition){
            
            ForEach(worldCupStore.estadios){ estadio in
                
                if showStadiums{
                    Annotation(estadio.nombre, coordinate: estadio.ubicacion.coordinate){
                        MarkerView(imageName: "soccerball.inverse",colorBackground: Color.green,color:.black)
                            .onTapGesture {
                                currentModal = .estadio(estadio.id)
                        }
                            .accessibilityLabel("Estadio \(estadio.nombre), \(estadio.ciudad)")
                            .accessibilityHint("Toca para ver detalles del estadio")
                    }
                }
               
            }
            
            ForEach(worldCupStore.fanfests){ fanFest in
                
                if showFanFests{
                    Annotation(fanFest.nombre, coordinate: fanFest.ubicacion.coordinate) {
                        MarkerView(imageName: "party.popper.fill",colorBackground: Color.black,color:.white)
                            .onTapGesture {
                                currentModal = .fanFest(fanFest.id)
                            }
                            .accessibilityLabel("FanFest \(fanFest.nombre) en \(fanFest.ciudad)")
                            .accessibilityHint("Toca para ver detalles del FanFest")
                    }
                }
               
            }
            
            
            
            // Anotacion del usuario
            UserAnnotation()
            
            
        }.onAppear{
            locationManager.requestWhenInUseAuthorization( )
        
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }
        .mapStyle(.standard(elevation: .automatic))
        .overlay {
            VStack{
                HStack(spacing: 13){
                    Button {
                        withAnimation {
                            showFanFests.toggle()
                        }
                    } label: {
                        Text(showFanFests ? "Hide FanFets":"Show FanFests")
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(showFanFests ? "Ocultar FanFests" : "Mostrar FanFests")
                    .accessibilityHint("Toca para alternar la visibilidad de los FanFests")
    
                    Button {
                        withAnimation {
                            showStadiums.toggle()
                        }
                    } label: {
                        Text(showStadiums ? "Hide Stadiums":"Show Stadiums")
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(showStadiums ? "Ocultar Estadios" : "Mostrar Estadios")
                    .accessibilityHint("Toca para alternar la visibilidad de los estadios")
                    
                }
                

                Spacer()
                HStack{
                    
                    Spacer()
                
                    GlassEffectContainer(spacing: 10){
                        VStack(spacing: 10){
                            
                            if isExpanded{
                                
                                ForEach(badges){ badge in
                                    ButtonView(badge: badge)
                                        .glassEffectID(badge.id, in: namespace)
                                        .onTapGesture {
                                            currentModal = badge.type
                                            isExpanded = false
                                        }
                                        .accessibilityLabel({
                                            switch badge.type {
                                            case .estadioList:
                                                return "Estadios"
                                            case .fanFestList:
                                                return "Fan Fests"
                                            case .traductor:
                                                return "Traductor"
                                            default:
                                                return "Opción"
                                            }
                                        }())
                                        .accessibilityHint("Toca para abrir esta opción")
                                }
                         
                            }
                            
                            ButtonToggle(show: $isExpanded)
                                .glassEffectID("badgeToggle", in: namespace)
                                .popoverTip(TipUno(),arrowEdge: .trailing)
                                .accessibilityLabel(isExpanded ? "Cerrar menú de opciones" : "Abrir menú de opciones")
                                .accessibilityHint("Toca para expandir o contraer el menú de opciones")
                        }
                        
                    }
                    
                    
                 
                    
                }.padding()
              
            }
        }
        .sheet(item: $currentModal) { route in
            switch route{
            case .estadioList:
                // vista de la lista de los estadio
                StadiumsList(showEstadiums: $showStadiums)
                
            case .fanFestList:
               // vista de la lista de los fanfest
                FanFestList(showFanfests: $showFanFests)
                
            case .traductor:
                
                // vista del traductor ( bini )

                TraductorView()
                
            case .estadio(let id):
                
                // vista personalizada del estadio
                
                if let estadio = worldCupStore.estadios.first(where: {$0.id == id}) {
                    StadiumDetail(estadio: estadio)
                        .presentationDetents([.medium,.large],selection: $sheetPresentation)
                }
               
                
            case .fanFest(let id):
                
                if let fanfest = worldCupStore.fanfests.first(where: {$0.id==id}){
                    FanFestDetail(fanFest: fanfest)
                }
                
                // vista personzalizada del fan fest
                
               EmptyView()
                
            }
               
        }
    }
}


#Preview {
    MapView().environmentObject(WorldCupStore())
}
