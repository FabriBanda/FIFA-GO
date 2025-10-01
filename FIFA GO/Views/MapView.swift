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
    
    let locationManager = CLLocationManager()
    
    var body: some View {
        Map(position:$cameraPosition){
            
//            Annotation("Lumen", coordinate: <#T##CLLocationCoordinate2D#>) {
//
//            }
            
            
            
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
                StadiumsList(cameraPosition: $cameraPosition)
            case .fanFestList:
                VStack{
                    Text("Lista de fan fests")
                }
                
            case .traductor:
                VStack{
                    Text("Vista del traductor")
                }
                
            case .estadio:
                VStack{
                    Text("Vista personalizada de estadio")
                }
            case .fanFest:
                VStack{
                    Text("Vista personalizada del fan fest")
                }
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
    MapView()
}
