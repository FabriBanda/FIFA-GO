import SwiftUI
import MapKit

struct StadiumDetail: View {
    @State private var showTicket = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isLoadingScene = false
    @State private var loadTask: Task<Void, Never>?

    @EnvironmentObject var worldCupStore: WorldCupStore
    let estadio: Estadio
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(estadio.nombre)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.primary)
                    .accessibilityLabel("Estadio \(estadio.nombre), \(estadio.ciudad)")
                    .accessibilityAddTraits(.isHeader)
                
                Text("Stadium")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                // MARK: Look Around / Fallback
                Group {
                    if let _ = lookAroundScene {
                        LookAroundPreview(scene: $lookAroundScene)
                            .frame(height: 220)
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
                
                // MARK: Botones
                HStack(spacing: 15) {
                    Button {
                        worldCupStore.abrirEnMapas(
                            lat: estadio.ubicacion.lat,
                            lon: estadio.ubicacion.lon,
                            nombre: estadio.nombre
                        )
                    } label: {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.green)
                                .bold()
                            Text("Open in Maps")
                        }
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel("Abrir en Google Maps la ubicación del estadio")
                    .accessibilityHint("Toca para abrir la ubicación del estadio en Google Maps")
                    
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
                    .accessibilityLabel("Encontrar mi puerta")
                    .accessibilityHint("Toca para encontrar tu puerta de acceso al estadio")
                }
                
                // MARK: Ticket
                if showTicket {
                    TicketView()
                }
                
                // MARK: Partidos
                VStack {
                    Text("Matches Today")
                        .font(.title3)
                        .bold()
                    Divider()
                    
                    let juegos = worldCupStore.getPartidos(enEstadio: estadio.id)
                    
                    List(juegos) { partido in
                        MatchView(showAllHorizontal: false, partido: partido)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
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
        // ✅ Lifecycle: cargar al aparecer, liberar al salir
        .onAppear { loadLookAround() }
        .onDisappear { unloadLookAround() }
    }
    
    // MARK: - Look Around Lifecycle
    private func loadLookAround() {
        isLoadingScene = true
        lookAroundScene = nil
        loadTask?.cancel()
        
        loadTask = Task {
            let req = MKLookAroundSceneRequest(coordinate: estadio.ubicacion.coordinate)
            let scene = try? await req.scene
            if Task.isCancelled { return }
            await MainActor.run {
                self.lookAroundScene = scene
                self.isLoadingScene = false
            }
        }
    }

    private func unloadLookAround() {
        // Cancela y libera para evitar fugas de memoria
        loadTask?.cancel()
        loadTask = nil
        lookAroundScene = nil
        isLoadingScene = false
    }
}


struct MatchView: View {
    let showAllHorizontal: Bool
    let partido: Partido
    
    var body: some View {
        VStack {
            HStack {
                if !showAllHorizontal { Spacer() }
                
                Text(partido.equipo1.bandera + partido.equipo1.nombre)
                    .font(.title3)
                    .bold()
                
                if showAllHorizontal {
                    Text("vs")
                        .font(.title3)
                        .bold()
                } else {
                    Spacer()
                }
                
                Text(partido.equipo2.nombre + partido.equipo2.bandera)
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                if showAllHorizontal {
                    Text(partido.inicio, style: .time)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            
            if !showAllHorizontal {
                Text(partido.inicio, style: .time)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// #Preview {
//    let store = WorldCupStore()
//    StadiumDetail(estadio: store.estadios[1])
//         .environmentObject(store)
//}
