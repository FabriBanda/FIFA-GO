//
//  Model.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 30/09/25.
//

import Foundation
import MapKit


struct Coordenada: Codable, Hashable {
    var lat: Double
    var lon: Double
    var coordinate: CLLocationCoordinate2D { .init(latitude: lat, longitude: lon) }
}

enum TipoEvento: String, Codable, CaseIterable {
    case liveBroadcasts = "liveBroadcasts"
    case liveEvents = "liveEvents"
    case activities = "activities"
   
}

enum VenueType: String, Codable, CaseIterable {
    case estadio
    case fanFest
}

enum ModalRoute: Identifiable {
    case estadioList
    case fanFestList
    case traductor
    case estadio(String)   // <- String
    case fanFest(String)   // <- String

    var id: String {
        switch self {
        case .estadioList: return "estadioList"
        case .fanFestList: return "fanFestList"
        case .traductor:   return "traductor"
        case .estadio(let id): return "estadio-\(id)"
        case .fanFest(let id): return "fanFest-\(id)"
        }
    }
}

struct Accesibilidad: Codable, Hashable {
    var sillaRuedas: Bool
    var personalApoyo: Bool
}

struct Estadio: Identifiable, Codable, Hashable {
    var id: String
    var nombre: String
    var imagenAssetName: String
    var ubicacion: Coordenada
    var puertas: [Coordenada]
    var accesibilidad: Accesibilidad?
}

struct FanFest: Identifiable, Codable, Hashable {
    var id: String
    var nombre: String
    var imagenAssetName: String?
    var ubicacion: Coordenada
    var horario: DateInterval?
    var eventos: [String] = []        // IDs de Evento
    var lookAroundAvailable: Bool = false
    var accesibilidad: Accesibilidad?
    var web:String
}

struct Evento: Identifiable, Codable, Hashable {
    var id: String
    var titulo: String
    var tipo: TipoEvento
    var inicio: Date
    var fin: Date
    var allDay: Bool = false
    var venueID: String
    var venueType: VenueType
    // opcional: para broadcasts
    var equipo1Id: String?
    var equipo2Id: String?
}

struct Equipo: Identifiable, Codable, Hashable {
    var id: String
    var nombre: String
    var bandera: String
}

struct Partido: Identifiable, Codable, Hashable {
    var id: String
    var equipo1: Equipo
    var equipo2: Equipo
    var inicio: Date
    var estadioID: String            // <- String
}


// MARK: - Helpers de FanFest

extension FanFest {
    var isOpenNow: Bool {
        guard let h = horario else { return false }
        return h.contains(Date())
    }
    var openTodayString: String? {
        guard let h = horario else { return nil }
        let fmt = DateFormatter()
        fmt.locale = .current
        fmt.timeStyle = .short
        fmt.dateStyle = .none
        return "OPEN TODAY \(fmt.string(from: h.start)) – \(fmt.string(from: h.end))"
    }
}
