import SwiftUI
import MapKit
import AVFoundation

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
<<<<<<< HEAD
            VStack {
                Text(estadio.nombre)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.primary)
                    .accessibilityLabel(String(format: String(localized: "stadium.detail.header", defaultValue: "Stadium %@, %@"), estadio.nombre, estadio.ciudad))
                    .accessibilityAddTraits(.isHeader)
                
                Text(String(localized: "stadium.type", defaultValue: "Stadium"))
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
                            Text(String(localized: "open.in.maps", defaultValue: "Open in Maps"))
                        }
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(String(localized: "open.maps.hint", defaultValue: "Tap to open stadium location in Google Maps"))
                    .accessibilityHint(String(localized: "open.maps.hint", defaultValue: "Tap to open stadium location in Google Maps"))
                    
                    Button {
                        withAnimation { showTicket.toggle() }
                    } label: {
                        HStack {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.red)
                                .bold()
                            Text(String(localized: "find.my.gate", defaultValue: "Find My Gate"))
                        }
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(String(localized: "find.my.gate", defaultValue: "Find My Gate"))
                    .accessibilityHint(String(localized: "find.gate.hint", defaultValue: "Tap to find your stadium access gate"))
                }
                
                // MARK: Ticket
                if showTicket {
                    TicketView()
                }
                
                // MARK: Partidos
                VStack {
                    Text(String(localized: "matches.today", defaultValue: "Matches Today"))
                        .font(.title3)
                        .bold()
                    Divider()
=======
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
>>>>>>> 3d946fe66c6a92d6f6b535d5ed2db5a59afa79f8
                    
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        setupAudioSession()
                        speakDescription(for: estadio, store: worldCupStore)
                    } label: {
                        Image(systemName: "voiceover")
                            .foregroundStyle(.black)
                            .font(.headline)
                    }
                    .accessibilityLabel("View description")
                    .accessibilityHint("Tap to listen to a description of this stadium")
                }
            }
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

func setupAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(.playback, mode: .default)
        try audioSession.setActive(true)
        
    } catch {
        print("Error setting up audio session: \(error.localizedDescription)")
    }
}

func speakDescription(for estadio: Estadio, store: WorldCupStore) {
    var parts: [String] = []

    parts.append("You're viewing \(estadio.nombre).")
    parts.append("This is one of the World Cup stadiums where matches are being held.")

    // Location guidance without relying on unavailable city field
    parts.append("You can view the location details on the map preview or open it in Maps.")

    parts.append("Use the Look Around preview to explore the surrounding area, or open the location in Maps.")

    // Describe today's matches at this stadium
    let juegos = store.getPartidos(enEstadio: estadio.id)
    if juegos.isEmpty {
        parts.append("There are no matches listed here today.")
    } else {
        let count = juegos.count
        let countPhrase = count == 1 ? "There is 1 match scheduled today." : "There are \(count) matches scheduled today."
        parts.append(countPhrase)

        // Summarize a few matches
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none

        let summaries = juegos.prefix(3).map { partido in
            let timeString = formatter.string(from: partido.inicio)
            return "\(partido.equipo1.nombre) versus \(partido.equipo2.nombre) at \(timeString)"
        }
        if !summaries.isEmpty {
            parts.append("Upcoming matches include: \(summaries.joined(separator: ", ")).")
        }
        if juegos.count > 3 { parts.append("And more.") }
    }

    let description = parts.joined(separator: " ")

    let utterance = AVSpeechUtterance(string: description)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate

    SpeechSynthesizer.shared.speak(utterance)
}

private final class SpeechSynthesizer {
    static let shared = AVSpeechSynthesizer()
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

 #Preview {
    let store = WorldCupStore()
    StadiumDetail(estadio: store.estadios[1])
        .environmentObject(store)
}

