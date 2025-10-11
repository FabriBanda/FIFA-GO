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
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @State private var showStadiums: Bool = true
    @State private var showFanFests: Bool = false
    
    @State private var sheetPresentation = PresentationDetent.medium
    @State private var currentModal: ModalRoute?
    @State private var isExpanded: Bool = false
    
    @EnvironmentObject var worldCupStore: WorldCupStore
    
    let locationManager = CLLocationManager()
    
    var body: some View {
        Map(position: $worldCupStore.cameraPosition) {
            
            // Estadios
            ForEach(worldCupStore.estadios) { estadio in
                if showStadiums {
                    Annotation(estadio.nombre, coordinate: estadio.ubicacion.coordinate) {
                        MarkerView(imageName: "soccerball.inverse", colorBackground: .green, color: .black)
                            .onTapGesture { currentModal = .estadio(estadio.id) }
                            .accessibilityLabel("Estadio \(estadio.nombre), \(estadio.ciudad)")
                            .accessibilityHint("Toca para ver detalles del estadio")
                    }
                }
            }
            
            // Fan Fests
            ForEach(worldCupStore.fanfests) { fanFest in
                if showFanFests {
                    Annotation(fanFest.nombre, coordinate: fanFest.ubicacion.coordinate) {
                        MarkerView(imageName: "party.popper.fill", colorBackground: .black, color: .white)
                            .onTapGesture { currentModal = .fanFest(fanFest.id) }
                            .accessibilityLabel("FanFest \(fanFest.nombre) en \(fanFest.ciudad)")
                            .accessibilityHint("Toca para ver detalles del FanFest")
                    }
                }
            }
            
            // Posición del usuario
            UserAnnotation()
        }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }
        .mapStyle(.standard(elevation: .automatic))
        .overlay {
            VStack {
                // Toggle chips (íconos con glassEffect + accesibilidad)
                HStack(spacing: 13) {
                    Button {
                        withAnimation { showFanFests.toggle() }
                    } label: {
                        Image(systemName: "party.popper.fill")
                            .font(dynamicType.showExpandView ? .system(size: 38) : .headline)
                            .foregroundStyle(showFanFests ? .white : Color.primary)
                            .bold()
                    }
                    .padding()
                    .glassEffect(.regular.interactive().tint(showFanFests ? .colorKansas : .clear))
                    .scaleEffect(showFanFests ? 1.2 : 1)
                    .accessibilityLabel(showFanFests ? "Ocultar FanFests" : "Mostrar FanFests")
                    .accessibilityHint("Toca para alternar la visibilidad de los FanFests")
                    
                    Button {
                        withAnimation { showStadiums.toggle() }
                    } label: {
                        Image(systemName: "sportscourt.fill")
                            .font(dynamicType.showExpandView ? .system(size: 43) : .title2)
                            .foregroundStyle(showStadiums ? .white : Color.primary)
                            .bold()
                    }
                    .padding(20)
                    .glassEffect(.regular.interactive().tint(showStadiums ? .colorBoston : .clear), in: Circle())
                    .scaleEffect(showStadiums ? 1.2 : 1)
                    .accessibilityLabel(showStadiums ? "Ocultar Estadios" : "Mostrar Estadios")
                    .accessibilityHint("Toca para alternar la visibilidad de los estadios")
                }
                
                Spacer()
                
                // FAB expandible
                HStack {
                    Spacer()
                    GlassEffectContainer(spacing: 10) {
                        VStack(spacing: 10) {
                            if isExpanded {
                                ForEach(badges) { badge in
                                    ButtonView(badge: badge)
                                        .glassEffectID(badge.id, in: namespace)
                                        .onTapGesture {
                                            currentModal = badge.type
                                            isExpanded = false
                                        }
                                        .accessibilityLabel({
                                            switch badge.type {
                                            case .estadioList: return "Estadios"
                                            case .fanFestList: return "Fan Fests"
                                            case .traductor:   return "Traductor"
                                            default:           return "Opción"
                                            }
                                        }())
                                        .accessibilityHint("Toca para abrir esta opción")
                                }
                            }
                            
                            ButtonToggle(show: $isExpanded)
                                .glassEffectID("badgeToggle", in: namespace)
                                .popoverTip(TipUno(), arrowEdge: .trailing)
                                .accessibilityLabel(isExpanded ? "Cerrar menú de opciones" : "Abrir menú de opciones")
                                .accessibilityHint("Toca para expandir o contraer el menú de opciones")
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(item: $currentModal) { route in
            switch route {
            case .estadioList:
                StadiumsList(showEstadiums: $showStadiums)
            case .fanFestList:
                FanFestList(showFanfests: $showFanFests)
            case .traductor:
                TraductorView()
            case .estadio(let id):
                if let estadio = worldCupStore.estadios.first(where: { $0.id == id }) {
                    StadiumDetail(estadio: estadio)
                        .presentationDetents([.medium, .large], selection: $sheetPresentation)
                }
            case .fanFest(let id):
                if let fanfest = worldCupStore.fanfests.first(where: { $0.id == id }) {
                    FanFestDetail(fanFest: fanfest)
                }
            }
        }
    }
}

#Preview {
    MapView().environmentObject(WorldCupStore())
}
