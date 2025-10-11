//
//  FanFestDetail.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 05/10/25.
//


import SwiftUI
import MapKit
import AVFoundation

struct FanFestDetail: View {
    let fanFest:FanFest
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var worldCupStore:WorldCupStore

    @State private var isLoadingScene = false
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var loadTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            VStack{
                VStack(spacing: 0){
                    Image(fanFest.ciudad)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250,height: 180)
                        .padding(.bottom)
                    
                    

                    Group {
                        if let _ = lookAroundScene {
                            LookAroundPreview(scene: $lookAroundScene)
                                .frame(height: 215)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.bottom, 8)
                        } else if isLoadingScene {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .frame(height: 215)
                                ProgressView("Cargando vista previa…")
                            }
                            .padding(.bottom, 8)
                        } else {
                            Map(initialPosition: .region(.init(
                                center: fanFest.ubicacion.coordinate,
                                latitudinalMeters: 1200,
                                longitudinalMeters: 1200
                            ))) {
                                Annotation(fanFest.nombre, coordinate: fanFest.ubicacion.coordinate) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)
                                        .foregroundStyle(.red)
                                }
                            }
                            .frame(height: 215)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .overlay{
                        VStack{
                            HStack{
                                Spacer()
                                // OpenToday().padding(5)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }

                ScrollView {
                    VStack(alignment: .leading){
                        let eventosFanFest = worldCupStore.eventosEnFanFest(fanFest.id)
                        ForEach(TipoEvento.allCases, id: \.self) { tipo in
                            if let eventos = eventosFanFest[tipo] {
                                Text(title(for: tipo))
                                    .font(.title2)
                                    .bold()
                                    .padding(.vertical, 4)
                                ForEach(eventos) { evento in
                                    EventoView(evento: evento)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)

                HStack{
                    NavigationLink(destination: WebApi(url:fanFest.web)) {
                        TextBottom(text: "Open Web")
                    }
                    TextBottom(text: "Get Directions")
                }

                Spacer()
            }
            .background(Gradient(colors: [getColorFanFest(name: fanFest.ciudad), Color(.systemBackground)]))
            .onAppear {
                setupAudioSession()
                loadLookAround() }
            .onDisappear { unloadLookAround() }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .font(.headline)
                
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        speakDescription()
                                        
                                    } label: {
                                        Image(systemName: "voiceover")
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                    }
                                    .accessibilityLabel("View description")
                                    .accessibilityHint("Tap to listen a description")
                                }
                            }
                    
                        
    
                        
                    }
                }
            }
        }
    }

    func formatDateInterval(_ interval: DateInterval) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: interval.start)) - \(formatter.string(from: interval.end))"
    }

    func title(for tipo: TipoEvento) -> String {
        switch tipo {
        case .liveEvents: return "Live Events"
        case .activities: return "Activities"
        case .liveBroadcasts: return "Live Broadcasts"
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
    
    func speakDescription() {
        // Build a clear, human-friendly description
        var parts: [String] = []

        parts.append("You're seeing \(fanFest.nombre).")
        parts.append("Here you can discover the events happening at the festival, from live performances to interactive activities.")
        parts.append("You can also watch live broadcasts of the events, if available.")

        // Describe location without coordinates; prefer city name if available
        if !fanFest.ciudad.isEmpty {
            parts.append("It's located in \(fanFest.ciudad.capitalized).")
        } else {
            parts.append("It's located at the festival venue.")
        }

        parts.append("In the Look Around preview, you can explore the festival grounds and discover more about the venue.")

        let eventosFanFest = worldCupStore.eventosEnFanFest(fanFest.id)
        if let broadcasts = eventosFanFest[.liveBroadcasts] {
            if broadcasts.isEmpty {
                parts.append("There are currently no live broadcasts available.")
            } else {
                let count = broadcasts.count
                let countPhrase = count == 1 ? "There is 1 live broadcast available." : "There are \(count) live broadcasts available."
                parts.append(countPhrase)
                // Read the titles in a single sentence
                let titles = broadcasts.map { $0.titulo }.joined(separator: ", ")
                parts.append("Broadcasts include: \(titles).")
            }
        }

        let description = parts.joined(separator: " ")

        // Configure and speak
        let utterance = AVSpeechUtterance(string: description)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate

        // Keep a synthesizer alive for the duration of speech by using a static shared instance.
        SpeechSynthesizer.shared.speak(utterance)
    }

    private final class SpeechSynthesizer {
        static let shared = AVSpeechSynthesizer()
    }

    // MARK: - Look Around lifecycle

    private func loadLookAround() {
        isLoadingScene = true
        lookAroundScene = nil
        loadTask?.cancel()
        loadTask = Task {
            let req = MKLookAroundSceneRequest(coordinate: fanFest.ubicacion.coordinate)
            let scene = try? await req.scene
            if Task.isCancelled { return }
            await MainActor.run {
                self.lookAroundScene = scene
                self.isLoadingScene = false
            }
        }
    }

    private func unloadLookAround() {
        // Cancela cualquier carga pendiente y suelta la escena para liberar memoria
        loadTask?.cancel()
        loadTask = nil
        lookAroundScene = nil
        isLoadingScene = false
    }

    private func reloadLookAroundIfNeeded() {
        // Si la vista sigue en pantalla y cambió el lugar, recarga
        if lookAroundScene != nil || isLoadingScene {
            loadLookAround()
        }
    }

    private func getColorFanFest(name:String)->Color{
        switch name{
        case "mexicocity": return Color.colorMexico
        case "seattle": return Color.colorSeattle
        case "monterrey": return Color.colorMonterrey
        case "guadalajara": return Color.colorGuadalajara
        case "toronto": return Color.colorToronto
        case "vancouver" : return Color.colorVancouver
        case "boston": return Color.colorBoston
        case "atlanta": return Color.colorAtlanta
        case "philadelphia" : return Color.colorPhiladelphia
        case "kansas": return Color.colorKansas
        case "losangeles": return Color.primary
        case "houston": return Color.colorHouston
        case "sanfrancisco": return Color.colorSanfrancisco
        case "miami": return Color.colorMiami
        case "newjersey": return Color.primary
        case "dallas": return Color.primary
        default: return Color.primary
        }
    }
}

struct OpenToday:View {
    var body: some View {
        VStack{
            Text("OPEN TODAY").font(.headline)
            Text("10:00 AM - 10:00 PM").font(.caption)
        }
        .bold()
        .foregroundStyle(Color.openTodayFont)
        .padding()
        .background(Color.openTodayBackground,in:RoundedRectangle(cornerRadius: 20))
    }
}

struct TextFanFest:View {
    let text:String
    var body: some View {
        Text(text)
            .font(.body)
            .bold()
            .foregroundStyle(.primary)
            .minimumScaleFactor(0.6)
    }
}

struct TextBottom:View {
    let text:String
    var body: some View {
        Text(text)
            .foregroundStyle(Color(.label))
            .padding()
            .glassEffect()
    }
}

// #Preview {
//     let store = WorldCupStore()
//     FanFestDetail(fanFest: store.fanfests[0]).environmentObject(store)
// }

#Preview {
    let fanfest = WorldCupStore()
    FanFestDetail(fanFest: fanfest.fanfests[0]).environmentObject(fanfest)
}

