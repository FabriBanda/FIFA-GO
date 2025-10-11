import SwiftUI
import MapKit
import AVFoundation

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

