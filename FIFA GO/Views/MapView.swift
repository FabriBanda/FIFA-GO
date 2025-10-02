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
    
    @State private var cameraPosition:MapCameraPosition = .region(.userRegion)
    
    @State private var currentModal : ModalRoute?
    
    @State private var isExpanded : Bool = false
    
    @EnvironmentObject var worldCupStore:WorldCupStore
    
    let locationManager = CLLocationManager()
    
    var body: some View {
        Map(position:$cameraPosition){
            
            ForEach(worldCupStore.estadios){ estadio in
                Annotation(estadio.nombre, coordinate: estadio.ubicacion.coordinate){
                    MarkerView(imageName: "soccerball.inverse",colorBackground: Color.green,color:.black)
                        .onTapGesture {
//                            withAnimation {
//                                cameraPosition = .region(MKCoordinateRegion(center: estadio.ubicacion.coordinate, latitudinalMeters: 500, longitudinalMeters: 500))
//                            }
                            currentModal = .estadio(estadio.id)
                    }
                }
            }
            
            ForEach(worldCupStore.fanfests){ fanFest in
                Annotation(fanFest.nombre, coordinate: fanFest.ubicacion.coordinate) {
                    MarkerView(imageName: "party.popper.fill",colorBackground: Color.black,color:.white)
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
                                }
                         
                            }
                            
                            ButtonToggle(show: $isExpanded)
                                .glassEffectID("badgeToggle", in: namespace)
                                .popoverTip(TipUno(),arrowEdge: .trailing)
                        }
                        
                    }
                    
                    
                 
                    
                }.padding()
              
            }
        }
        .sheet(item: $currentModal) { route in
            switch route{
            case .estadioList:
                // vista de la lista de los estadio
                StadiumsList(cameraPosition: $cameraPosition)
                
            case .fanFestList:
               // vista de la lista de los fanfest
                EmptyView()
                
            case .traductor:
                
                // vista del traductor ( bini )
                EmptyView()
            case .estadio(let id):
                
                // vista personalizada del estadio
                
                if let estadio = worldCupStore.estadios.first(where: {$0.id == id}) {
                    StadiumDetail(estadio: estadio)
                        .presentationDetents([.medium,.large])
                }
               
                
            case .fanFest:
                
                // vista personzalizada del fan fest
                
               EmptyView()
                
            }
               
        }
    }
}


extension MKCoordinateRegion {
    static var userRegion : MKCoordinateRegion {
        return .init(center: .init(latitude: 37.3346, longitude: -122.0090), latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}


#Preview {
    MapView().environmentObject(WorldCupStore())
}
