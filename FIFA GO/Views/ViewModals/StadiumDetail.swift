import SwiftUI
import MapKit

struct StadiumDetail: View {
    @State private var showTicket = false
    @Environment(\.dismiss) private var dismiss

    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isLoadingScene = false

    let estadio: Estadio

    var body: some View {
        NavigationStack {
            VStack{
                Text(estadio.nombre)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.primary)

                Text("Stadium")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // Look Around / Fallback
                Group {
                    if let _ = lookAroundScene {
                        LookAroundPreview(scene: $lookAroundScene)
                            .frame(height: 220) // IMPORTANTE: altura fija
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.bottom, 8)
                    } else if isLoadingScene {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .frame(height: 220)
                            ProgressView("Cargando vista previa…")
                        }
                        .padding(.bottom, 8)
                    } else {
                        // Fallback si no hay cobertura de Look Around
                        Map(initialPosition: .region(.init(
                            center: estadio.ubicacion.coordinate,
                            latitudinalMeters: 1200,
                            longitudinalMeters: 1200
                        ))) {
                            Annotation(estadio.nombre, coordinate: estadio.ubicacion.coordinate) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.red)
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }

                HStack(spacing: 15) {
                    Button {
                        // Abrir en Apple Maps con nombre y coordenada
                        
                    } label: {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.green)
                                .bold()
                            Text("Open in Maps")
                        }
                    }
                    .buttonStyle(.glass)

                    Button {
                        withAnimation { showTicket.toggle() }
                    } label: {
                        HStack {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.red)
                                .bold()
                            Text("Find My Gate")
                        }
                    }
                    .buttonStyle(.glass)
                }

                if showTicket {
                    TicketView()
                }

                VStack {
                    Text("Matches Today")
                        .font(.title3)
                        .bold()
                    Divider()

                    // Demo / placeholder
                    MatchView(
                        partido: Partido(
                            id: UUID(),
                            equipo1: Equipo(id: UUID(), nombre: "Mexico", bandera: "🇲🇽"),
                            equipo2: Equipo(id: UUID(), nombre: "Canada", bandera: "🇨🇦"),
                            inicio: Date.now,
                            estadioID: estadio.id
                        )
                    )
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").bold()
                    }
                }
            }
        }
        .onAppear { loadLookAround() }
        // Si cambias de estadio con la sheet abierta, vuelve a cargar
        .onChange(of: estadio.id) { _, _ in loadLookAround() }
        .onChange(of: estadio.ubicacion.lat) { _, _ in loadLookAround() }
        .onChange(of: estadio.ubicacion.lon) { _, _ in loadLookAround() }
    }

    // MARK: - Look Around loader

    private func loadLookAround() {
        isLoadingScene = true
        lookAroundScene = nil

        Task {
            // Solicitud por coordenada (no necesitas MKMapItem ni MKAddress)
            let req = MKLookAroundSceneRequest(coordinate: estadio.ubicacion.coordinate)
            let scene = try? await req.scene
            await MainActor.run {
                self.lookAroundScene = scene
                self.isLoadingScene = false
            }
        }
    }
}

// === Tus subviews existentes ===

struct TicketView: View {
    var body: some View {
        VStack {
            Image("ticket")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
            Button {
                // lógica de búsqueda de puerta
            } label: {
                HStack {
                    Spacer()
                    Text("Search Gate")
                        .font(.headline)
                        .bold()
                    Spacer()
                }
            }
            .buttonStyle(.glassProminent)
            .padding(.horizontal, 40)
        }
    }
}

struct MatchView: View {
    let partido: Partido
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(partido.equipo1.bandera + partido.equipo1.nombre)
                    .font(.title3)
                    .bold()
                Spacer()
                Text(partido.equipo2.nombre + partido.equipo2.bandera)
                    .font(.title3)
                    .bold()
                Spacer()
            }
            Text("11:00 am")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}
