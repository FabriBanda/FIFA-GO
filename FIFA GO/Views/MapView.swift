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
                            .accessibilityLabel(String(format: String(localized: "stadium.map.annotation", defaultValue: "Stadium %@, %@"), estadio.nombre, estadio.ciudad))
                            .accessibilityHint(String(localized: "stadium.map.hint", defaultValue: "Tap to view stadium details"))
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
                        Text(showFanFests ? String(localized: "hide.fanfests", defaultValue: "Hide FanFests") : String(localized: "show.fanfests", defaultValue: "Show FanFests"))
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(showFanFests ? String(localized: "hide.fanfests", defaultValue: "Hide FanFests") : String(localized: "show.fanfests", defaultValue: "Show FanFests"))
                    .accessibilityHint(String(localized: "toggle.fanfests.hint", defaultValue: "Tap to toggle FanFests visibility"))
    
                    Button {
                        withAnimation {
                            showStadiums.toggle()
                        }
                    } label: {
                        Text(showStadiums ? String(localized: "hide.stadiums", defaultValue: "Hide Stadiums") : String(localized: "show.stadiums", defaultValue: "Show Stadiums"))
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(showStadiums ? String(localized: "hide.stadiums", defaultValue: "Hide Stadiums") : String(localized: "show.stadiums", defaultValue: "Show Stadiums"))
                    .accessibilityHint(String(localized: "toggle.stadiums.hint", defaultValue: "Tap to toggle stadiums visibility"))
                    
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
                                                return String(localized: "menu.stadiums", defaultValue: "Stadiums")
                                            case .fanFestList:
                                                return String(localized: "menu.fanfests", defaultValue: "Fan Fests")
                                            case .traductor:
                                                return String(localized: "menu.translator", defaultValue: "Translator")
                                            default:
                                                return String(localized: "menu.option.hint", defaultValue: "Option")
                                            }
                                        }())
                                        .accessibilityHint(String(localized: "menu.option.hint", defaultValue: "Tap to open this option"))
                                }
                         
                            }
                            
                            ButtonToggle(show: $isExpanded)
                                .glassEffectID("badgeToggle", in: namespace)
                                .popoverTip(TipUno(),arrowEdge: .trailing)
                                .accessibilityLabel(isExpanded ? String(localized: "menu.close", defaultValue: "Close options menu") : String(localized: "menu.open", defaultValue: "Open options menu"))
                                .accessibilityHint(String(localized: "menu.toggle.hint", defaultValue: "Tap to expand or collapse the options menu"))
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
                EmptyView()
                
            case .traductor:
                
                // vista del traductor ( bini )
                //EmptyView()
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
