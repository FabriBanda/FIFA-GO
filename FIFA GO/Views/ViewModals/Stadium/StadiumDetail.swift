import SwiftUI
import MapKit

struct StadiumDetail: View {
    @State private var showTicket = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isLoadingScene = false
    
    @EnvironmentObject var worldCupStore:WorldCupStore
    
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
                        abrirEnMapas(lat: estadio.ubicacion.lat, lon: estadio.ubicacion.lon, nombre: estadio.nombre)
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
                    
                    let juegos = worldCupStore.getPartidos(enEstadio: estadio.id)
                    
                    ForEach(juegos) { partido in
                        MatchView(showAllHorizontal: false,partido: partido)
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
        }
        .onAppear { loadLookAround() }
        // Si cambias de estadio con la sheet abierta, vuelve a cargar
        .onChange(of: estadio.id) { _, _ in loadLookAround() }
        .onChange(of: estadio.ubicacion.lat) { _, _ in loadLookAround() }
        .onChange(of: estadio.ubicacion.lon) { _, _ in loadLookAround() }
    }
    
    func abrirEnMapas(lat: Double, lon: Double, nombre: String) {
        let url = URL(string: "maps://?q=\(nombre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&ll=\(lat),\(lon)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func loadLookAround() {
        isLoadingScene = true
        lookAroundScene = nil
        
        Task {
            
            let req = MKLookAroundSceneRequest(coordinate: estadio.ubicacion.coordinate)
            let scene = try? await req.scene
            await MainActor.run {
                self.lookAroundScene = scene
                self.isLoadingScene = false
            }
        }
    }
}



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
    
    let showAllHorizontal: Bool
    let partido: Partido
    var body: some View {
        VStack {
            HStack {
                if !showAllHorizontal{
                    Spacer()
                }
                Text(partido.equipo1.bandera + partido.equipo1.nombre)
                    .font(.title3)
                    .bold()
                if showAllHorizontal{
                    Text("vs")
                        .font(.title3)
                        .bold()
                    
                }else{
                    Spacer()
                }
                Text(partido.equipo2.nombre + partido.equipo2.bandera)
                    .font(.title3)
                    .bold()
                Spacer()
                if showAllHorizontal{
                    Text(partido.inicio,style: .time)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
               
            }
            if !showAllHorizontal{
                Text(partido.inicio,style: .time)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
          
        }
    }
}


//#Preview {
//    let store = WorldCupStore()
//    return StadiumDetail(estadio: store.estadios[1])
//        .environmentObject(store)
//}
