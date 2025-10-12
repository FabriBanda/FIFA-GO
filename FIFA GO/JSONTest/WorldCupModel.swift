//
//  WorldCupModel.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 05/10/25.
//

import Foundation

// MARK: - JSON DTOs

// Contenedor raíz del JSON
struct WorldCupDataDTO: Codable {
    let estadios: [Estadio]      
    let equipos:  [Equipo]
    let fanfests: [FanFestDTO]
    let eventos:  [EventoDTO]
    let partidos: [PartidoDTO]
}

struct FanFestDTO: Codable {
    let id: String
    let nombre: String
    let imagenAssetName: String?
    let ubicacion: Coordenada
    let horario: DateIntervalDTO?
    let eventos: [String]
    let lookAroundAvailable: Bool?
    let accesibilidad: Accesibilidad?
    let web:String
    let ciudad:String
    let pais:String
}

struct DateIntervalDTO: Codable {
    let inicio: String
    let fin: String
}

struct EventoDTO: Codable {
    let id: String
    let titulo: String
    let tipo: String               // "liveEvents" | "activities" | "liveBroadcasts"
    let inicio: String
    let fin: String
    let allDay: Bool?
    let venueID: String            // <- nota: si tu JSON usa "venueId", ver CodingKeys abajo
    let venueType: String          // "fanFest" | "estadio"
    let equipo1Id: String?
    let equipo2Id: String?

    enum CodingKeys: String, CodingKey {
        case id, titulo, tipo, inicio, fin, allDay, venueType, equipo1Id, equipo2Id
        case venueID = "venueId"   // mapea "venueId" del JSON → venueID en Swift
    }
}

struct PartidoDTO: Codable {
    let id: String?
    let equipo1Id: String
    let equipo2Id: String
    let inicio: String
    let estadioId: String
}
