//
//  WorldCupStore.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 01/10/25.
//

import Foundation
import Combine

class WorldCupStore : ObservableObject {
    
    @Published var estadios: [Estadio]
    @Published var fanfests: [FanFest]
    @Published var partidos: [Partido]
    
    
    init(){
        
        estadios = [
            
            // Mexico
            
            Estadio(nombre: "BBVA",imagenAssetName: "bbva", ubicacion: Coordenada(lat: 25.67119328280499, lon: -100.24416690079325), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "Azteca",imagenAssetName: "azteca", ubicacion: Coordenada(lat: 19.302911, lon: -99.150442), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),
                
            Estadio(nombre: "Akron",imagenAssetName: "akron", ubicacion: Coordenada(lat: 20.681670, lon: -103.462780), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),


            // Canada
            Estadio(nombre: "BCPLACE",imagenAssetName: "BCPLACE", ubicacion: Coordenada(lat: 49.276670, lon: -123.111940), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),
            Estadio(nombre: "BMO Field",imagenAssetName: "BMO", ubicacion: Coordenada(lat: 43.632780, lon: -79.418610), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),


            // Usa
            Estadio(nombre: "Arrow Head",imagenAssetName: "Arrowhead", ubicacion: Coordenada(lat: 39.048786, lon: -94.484566), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),
            Estadio(nombre: "AT&T",imagenAssetName: "AT&T", ubicacion: Coordenada(lat: 32.747780, lon: -97.092780), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "Gillete Stadium",imagenAssetName: "Gillete", ubicacion: Coordenada(lat: 42.091000, lon: -71.264000), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "Hard Rock",imagenAssetName: "HardRock", ubicacion: Coordenada(lat: 25.957960, lon: -80.239311), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "Levis",imagenAssetName: "Levis", ubicacion: Coordenada(lat: 37.403000, lon: -121.970000), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "Lincoln Financial",imagenAssetName: "LinconlnFinancial", ubicacion: Coordenada(lat: 39.900898, lon: -75.168098), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "Lumen",imagenAssetName: "Lumen", ubicacion: Coordenada(lat: 47.595097, lon: -122.332245), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "MercedesBenz",imagenAssetName: "MercedesBenz", ubicacion: Coordenada(lat: 33.755560, lon: -84.400000), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "Metlife",imagenAssetName: "metlife", ubicacion: Coordenada(lat: 40.813610, lon: -74.074440), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),

            Estadio(nombre: "NRG",imagenAssetName: "NRG", ubicacion: Coordenada(lat: 29.684720, lon: -95.410830), puertas: [Coordenada(lat: 0.0, lon: 0.0)]),
            Estadio(nombre: "Sofi",imagenAssetName: "SofiStadium", ubicacion: Coordenada(lat: 33.953000, lon: -118.339000), puertas: [Coordenada(lat: 0.0, lon: 0.0)])
            
            
            
            
            
            
        ]
        
        fanfests = [FanFest(nombre:"Seattle Center", ubicacion: Coordenada(lat: 47.6205888, lon: -122.3529166))]
        
        
        partidos = []
    
        
    }
    
}
