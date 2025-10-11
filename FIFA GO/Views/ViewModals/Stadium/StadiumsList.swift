import SwiftUI
import MapKit

struct StadiumsList: View {
    @State private var searchText: String = ""
    @State private var countryFilter: CountryFilter = .all
    @Binding var showEstadiums : Bool
    @EnvironmentObject var worldCupStore: WorldCupStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                // Filtro por país
                Picker("Country", selection: $countryFilter) {
                    ForEach(CountryFilter.allCases, id: \.self) { f in
                        Text(f.title).tag(f)
                            .font(.largeTitle)
                        
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(filteredAndSortedEstadios) { estadio in
                        EstadioRow(estadio: estadio)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                   
                                    showEstadiums = true
                                    worldCupStore.cameraPosition = .region(
                                        .init(center: estadio.ubicacion.coordinate,
                                              latitudinalMeters: 1000,
                                              longitudinalMeters: 1000)
                                    )
                                    dismiss()
                                    
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Stadiums")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer,
                        prompt: "Search Stadiums")
        }
    }

    // MARK: - Data derivada

    private var filteredAndSortedEstadios: [Estadio] {
        worldCupStore.estadios
            .filter { estadio in
                // Filtro por país
                countryFilter == .all || stadiumCountry(estadio) == countryFilter
            }
            .filter { estadio in
                // Filtro por búsqueda
                searchText.isEmpty ||
                estadio.nombre.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { $0.nombre.localizedCaseInsensitiveCompare($1.nombre) == .orderedAscending }
    }

    
    private func stadiumCountry(_ estadio: Estadio) -> CountryFilter {
        // Por ID (recomendado, estable)
        let id = estadio.id  // String en tu modelo actual
        if id.hasPrefix("E-AZTECA") || id.hasPrefix("E-AKRON") || id.hasPrefix("E-BBVA") {
            return .mexico
        }
        if id.hasPrefix("E-BCPLACE") || id.hasPrefix("E-BMO") {
            return .canada
        }
        // El resto de IDs conocidos del JSON son de USA
        return .usa
    }
}



private enum CountryFilter: String, CaseIterable {
    case all, mexico, usa, canada

    var title: String {
        switch self {
        case .all:    return "All"
        case .mexico: return "🇲🇽"
        case .usa:    return "🇺🇸"
        case .canada: return "🇨🇦"
        }
    }
}

private struct EstadioRow: View {
    let estadio: Estadio

    var body: some View {
        ZStack {
            Image(estadio.imagenAssetName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
                    .accessibilityLabel("Estadio \(estadio.nombre), ubicado en \(estadio.ciudad)")
           
        }
        .overlay(alignment: .bottom) {
            HStack {
                Spacer()
                Text(estadio.nombre)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.vertical, 8)
            .background(.black.opacity(0.45))
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}

