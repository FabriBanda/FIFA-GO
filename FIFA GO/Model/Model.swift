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

    init(_ c: CLLocationCoordinate2D) {
        self.lat = c.latitude
        self.lon = c.longitude
    }
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

// Enums

enum TipoEvento: String, Codable, CaseIterable {
    case liveEvents       = "Live Events"
    case activities       = "Activities"
    case liveBroadcasts   = "Live Broadcasts"
}

enum VenueType: String, Codable, CaseIterable {
    case estadio
    case fanFest
}

enum ModalRoute: Identifiable {
    case estadioList
    case fanFestList
    case traductor
    case estadio(UUID)
    case fanFest(UUID)

    var id: String {
        switch self {
        case .estadioList: return "estadioList"
        case .fanFestList: return "fanFestList"
        case .traductor: return "traductor"
        case .estadio(let id): return "estadio-\(id.uuidString)"
        case .fanFest(let id): return "fanFest-\(id.uuidString)"
        }
    }
}

// MARK: - Entidades

struct Accesibilidad: Codable, Hashable {
    var sillaRuedas: Bool
    var personalApoyo: Bool
}

struct Estadio: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var nombre: String
    var imagenAssetName: String?
    var ubicacion: Coordenada
    var puertas: [Coordenada]
    var accesibilidad: Accesibilidad?
    var lookAroundAvailable:Bool = false
    
}

struct FanFest: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var nombre: String
    var imagenAssetName: String?
    var ubicacion: Coordenada
    var horario: DateInterval?
    var eventos: [Evento.ID] = []
    var lookAroundAvailable: Bool = false
    var accesibilidad: Accesibilidad?
}

struct Evento: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var titulo: String
    var tipo: TipoEvento
    var inicio: Date
    var fin: Date
    var allDay: Bool = false
    var venueID: UUID
    var venueType: VenueType  // .fanFest / .estadio
}

struct Equipo: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var nombre: String
    var bandera: String // emoji de la bandera
}

struct Partido: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var equipo1: Equipo
    var equipo2: Equipo
    var inicio: Date
    var estadioID: Estadio.ID
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
