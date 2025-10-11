import SwiftUI
import MapKit

struct StadiumDetail: View {
    @State private var showTicket = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isLoadingScene = false
    @State private var loadTask: Task<Void, Never>?

    @Environment(\.dynamicTypeSize) var dynamicText
    @EnvironmentObject var worldCupStore: WorldCupStore
    let estadio: Estadio
    
    var body: some View {
        // Layout se adapta a Dynamic Type (vertical cuando el texto es grande)
        let layout = dynamicText.showExpandView
            ? AnyLayout(VStackLayout(spacing: 15))
            : AnyLayout(HStackLayout(spacing: 15))
        
        NavigationStack {
            ScrollView {
                VStack {
                    // MARK: - Encabezado
                    Text(estadio.nombre)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.primary)
                        .accessibilityLabel("Estadio \(estadio.nombre)")
                        .accessibilityAddTraits(.isHeader)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .multilineTextAlignment(.center)
                    
                    Text(LocalizedStringKey("Stadium"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .multilineTextAlignment(.center)
                    
                    // MARK: - Look Around / Fallback
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
                                ProgressView(LocalizedStringKey("Loading Preview…"))
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
                    
                    // MARK: - Botones
                    layout {
                        Button {
                            worldCupStore.abrirEnMapas(
                                lat: estadio.ubicacion.lat,
                                lon: estadio.ubicacion.lon,
                                nombre: estadio.nombre
                            )
                        } label: {
                            ButtonStadiumDetail(
                                nameImage: "location.fill",
                                text: "Open in Maps",
                                color: .green
                            )
                        }
                        .buttonStyle(.glass)
                        .accessibilityLabel("Abrir la ubicación del estadio en Mapas")
                        .accessibilityHint("Toca para abrir la ubicación del estadio en Apple Maps")
                        
                        Button {
                            withAnimation { showTicket.toggle() }
                        } label: {
                            ButtonStadiumDetail(
                                nameImage: "ticket.fill",
                                text: "Find My Gate",
                                color: .red
                            )
                        }
                        .buttonStyle(.glass)
                        .accessibilityLabel("Encontrar mi puerta")
                        .accessibilityHint("Toca para ver tu puerta de acceso al estadio")
                    }
                    .padding(.top)
                    
                    // MARK: - TicketView
                    if showTicket {
                        TicketView()
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .opacity
                            ))
                            .padding(.top)
                    }
                    
                    // MARK: - Partidos
                    VStack {
                        Text(LocalizedStringKey("Matches Today"))
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.center)
                        Divider()
                        
                        let juegos = worldCupStore.getPartidos(enEstadio: estadio.id)
                        ForEach(juegos) { partido in
                            MatchView(
                                equipo1: partido.equipo1,
                                equipo2: partido.equipo2,
                                hora: worldCupStore.timeString(from: partido.inicio),
                                showHorizontal: false
                            )
                        }
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
            }.background(Gradient(colors: [worldCupStore.getColorFanFest(name: estadio.ciudad).opacity(0.7),Color(.systemBackground)]))
        }
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
        loadTask?.cancel()
        loadTask = nil
        lookAroundScene = nil
        isLoadingScene = false
    }
}

#Preview {
    let store = WorldCupStore()
    StadiumDetail(estadio: store.estadios[12])
        .environmentObject(store)
}
