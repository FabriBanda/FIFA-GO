// WorldCupStore.swift
import Foundation
import MapKit
import SwiftUI
import Combine

class WorldCupStore: ObservableObject {
    @Published var estadios: [Estadio] = []
    @Published var fanfests: [FanFest] = []
    @Published var equipos:  [Equipo]  = []
    @Published var eventos:  [Evento]  = []
    @Published var partidos: [Partido] = []

    @Published var cameraPosition: MapCameraPosition =
        .region(.init(center: .init(latitude: 37.3346, longitude: -122.0090),
                      latitudinalMeters: 1000, longitudinalMeters: 1000))

    init() { loadFromJSON() }

    private func loadFromJSON() {
        guard
            let url  = Bundle.main.url(forResource: "WorldCupData", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            print("⚠️ No se encontró WorldCupData.json")
            return
        }

        do {
            let dto = try JSONDecoder().decode(WorldCupDataDTO.self, from: data)

            // Cargamos directos
            self.estadios = dto.estadios
            self.equipos  = dto.equipos

            // Parser ISO8601
            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            func d(_ s: String) -> Date? { iso.date(from: s) ?? ISO8601DateFormatter().date(from: s) }

            // Eventos (parseo de fecha y enums)
            self.eventos = dto.eventos.compactMap { e in
                guard
                    let inicio = d(e.inicio),
                    let fin    = d(e.fin),
                    let tipo   = TipoEvento(rawValue: e.tipo),
                    let vType  = VenueType(rawValue: e.venueType)
                else { return nil }

                return Evento(
                    id: e.id,
                    titulo: e.titulo,
                    tipo: tipo,
                    inicio: inicio,
                    fin: fin,
                    allDay: e.allDay ?? false,
                    venueID: e.venueID,
                    venueType: vType,
                    equipo1Id: e.equipo1Id,
                    equipo2Id: e.equipo2Id
                )
            }

            // FanFests (DateInterval y flags)
            self.fanfests = dto.fanfests.map { f in
                let intervalo: DateInterval? = {
                    guard let h = f.horario,
                          let i = d(h.inicio),
                          let e = d(h.fin) else { return nil }
                    return DateInterval(start: i, end: e)
                }()
                return FanFest(
                    id: f.id,
                    nombre: f.nombre,
                    imagenAssetName: f.imagenAssetName,
                    ubicacion: f.ubicacion,
                    horario: intervalo,
                    eventos: f.eventos,
                    accesibilidad: f.accesibilidad,
                    web: f.web,
                    ciudad: f.ciudad
                )
            }

            // Partidos (resolver equipos por id y estadio por id)
            self.partidos = dto.partidos.compactMap { p in
                guard
                    let fecha = d(p.inicio),
                    let e1 = equipos.first(where: { $0.id == p.equipo1Id }),
                    let e2 = equipos.first(where: { $0.id == p.equipo2Id })
                else { return nil }

                return Partido(
                    id: p.id ?? UUID().uuidString,
                    equipo1: e1,
                    equipo2: e2,
                    inicio: fecha,
                    estadioID: p.estadioId
                )
            }

            print("✅ Cargado: \(estadios.count) estadios, \(equipos.count) equipos, \(eventos.count) eventos, \(fanfests.count) fanfests, \(partidos.count) partidos")
        } catch {
            print("❌ Error decodificando WorldCupData.json: \(error)")
        }
    }

    // MARK: - Helpers
    func getPartidos(enEstadio estadioID: String) -> [Partido] {
        partidos
            .filter { $0.estadioID == estadioID }
            .sorted { $0.inicio < $1.inicio }
    }

    func eventosEnFanFest(_ fanFestID: String) -> [TipoEvento: [Evento]] {
        let evs = eventos.filter { $0.venueType == .fanFest && $0.venueID == fanFestID }
        return Dictionary(grouping: evs, by: { $0.tipo })
    }

    func equiposParaBroadcast(eventID: String) -> (Equipo, Equipo)? {
        guard
            let ev = eventos.first(where: { $0.id == eventID }),
            let id1 = ev.equipo1Id,
            let id2 = ev.equipo2Id,
            let e1 = equipos.first(where: { $0.id == id1 }),
            let e2 = equipos.first(where: { $0.id == id2 })
        else { return nil }
        return (e1, e2)
    }
    
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func abrirEnMapas(lat: Double, lon: Double, nombre: String) {
        let url = URL(string: "maps://?q=\(nombre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&ll=\(lat),\(lon)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    
}
