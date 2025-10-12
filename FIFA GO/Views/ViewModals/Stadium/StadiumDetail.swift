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
        // Layout adaptativo según Dynamic Type
        let layout = dynamicText.showExpandView
            ? AnyLayout(VStackLayout(spacing: 15))
            : AnyLayout(HStackLayout(spacing: 15))
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    // MARK: - Encabezado
                    Text(estadio.nombre)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.white)
                        .accessibilityLabel(
                            String(format: String(localized: "stadium.detail.header", defaultValue: "Stadium %@, %@"), estadio.nombre, estadio.ciudad)
                        )
                        .accessibilityAddTraits(.isHeader)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .multilineTextAlignment(.center)
                    
                    Text(String(localized: "stadium.type", defaultValue: "Stadium"))
                        .font(.subheadline)
                        .foregroundStyle(.white)
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
                                ProgressView(String(localized: "stadium.loadingPreview", defaultValue: "Loading preview…"))
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
                                text: String(localized: "open.in.maps", defaultValue: "Open in Maps"),
                                color: .green
                            )
                        }
                        .buttonStyle(.glass)
                        .accessibilityLabel(String(localized: "accessibility.open.maps", defaultValue: "Tap to open stadium location in Maps"))
                        .accessibilityHint(String(localized: "accessibility.open.maps.hint", defaultValue: "Opens Maps with stadium location"))
                        
                        Button {
                            withAnimation { showTicket.toggle() }
                        } label: {
                            ButtonStadiumDetail(
                                nameImage: "ticket.fill",
                                text: String(localized: "find.my.gate", defaultValue: "Find My Gate"),
                                color: .red
                            )
                        }
                        .buttonStyle(.glass)
                        .accessibilityLabel(String(localized: "accessibility.find.gate", defaultValue: "Find My Gate"))
                        .accessibilityHint(String(localized: "accessibility.find.gate.hint", defaultValue: "Tap to find your stadium access gate"))
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
                        Text(String(localized: "matches.today", defaultValue: "Matches Today"))
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.center)
                        Divider()
                        
                        let juegos = worldCupStore.getPartidos(enEstadio: estadio.id)
                        ForEach(juegos) { partido in
                            MatchView(equipo1: partido.equipo1,equipo2: partido.equipo2,hora: worldCupStore.timeString(from: partido.inicio),showHorizontal: false)
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").bold()
                            .foregroundStyle(.primary)
                    }
                    .accessibilityLabel(String(localized: "accessibility.close", defaultValue: "Close"))
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        setupAudioSession()
                        speakDescription(for: estadio, store: worldCupStore)
                    } label: {
                        Image(systemName: "voiceover")
                            .foregroundStyle(.primary)
                            .font(.headline)
                    }
                    .accessibilityLabel(String(localized: "accessibility.description", defaultValue: "View description"))
                    .accessibilityHint(String(localized: "accessibility.description.hint", defaultValue: "Tap to listen to a description of this stadium"))
                }
            }
        }
        .onAppear { loadLookAround() }
        .onDisappear { unloadLookAround() }
        .background(Gradient(colors: [worldCupStore.getColorFanFest(name:estadio.ciudad),Color(.systemBackground)]))
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
    
    parts.append(String(format: String(localized: "voiceover.stadium.viewing", defaultValue: "You're viewing %@."), estadio.nombre))
    parts.append(String(localized: "voiceover.stadium.info", defaultValue: "This is one of the World Cup stadiums where matches are being held."))
    parts.append(String(localized: "voiceover.stadium.location", defaultValue: "You can view the location details on the map preview or open it in Maps."))
    
    let juegos = store.getPartidos(enEstadio: estadio.id)
    if juegos.isEmpty {
        parts.append(String(localized: "voiceover.stadium.noMatches", defaultValue: "There are no matches listed here today."))
    } else {
        let count = juegos.count
        let countPhrase = count == 1 ?
            String(localized: "voiceover.stadium.oneMatch", defaultValue: "There is 1 match scheduled today.") :
            String(format: String(localized: "voiceover.stadium.multipleMatches", defaultValue: "There are %d matches scheduled today."), count)
        parts.append(countPhrase)
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        let summaries = juegos.prefix(3).map { partido in
            let timeString = formatter.string(from: partido.inicio)
            return "\(partido.equipo1.nombre) versus \(partido.equipo2.nombre) at \(timeString)"
        }
        if !summaries.isEmpty {
            parts.append(String(format: String(localized: "voiceover.stadium.upcomingMatches", defaultValue: "Upcoming matches include: %@."), summaries.joined(separator: ", ")))
        }
        if juegos.count > 3 { parts.append(String(localized: "voiceover.stadium.andMore", defaultValue: "And more.")) }
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
