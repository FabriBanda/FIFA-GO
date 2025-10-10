//
//  FanFestList.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 09/10/25.
//

import SwiftUI
import MapKit

struct FanFestList: View {
    @Binding var showFanfests : Bool
    @EnvironmentObject var worldCupStore: WorldCupStore
    @Environment(\.dismiss) private var dismiss
    @State private var countryFilter: CountryFilter = .all
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12){
                
                Picker("Select a Fan Fest", selection: $countryFilter) {
                    ForEach(CountryFilter.allCases, id: \.self) { filter in
                        Text(filter.title)
                            
                    }
                }.pickerStyle(.segmented)
                    .padding(.horizontal)
                
                List {
                    ForEach(filteredFamfests()) { fanfest in
                        RowList(name: fanfest.nombre, imageName: fanfest.imagenAssetName ?? "")
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    
                                    showFanfests = true
                                    worldCupStore.cameraPosition = .region(
                                        .init(center: fanfest.ubicacion.coordinate,
                                              latitudinalMeters: 1000,
                                              longitudinalMeters: 1000)
                                    )
                                    dismiss()
                                    
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }.navigationTitle("FanFests")
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
        }
    }
    
    private func filteredFamfests()->[FanFest]{
        switch countryFilter {
        case .all:
            return worldCupStore.fanfests
        case .mexico:
            return worldCupStore.fanfests.filter{$0.pais == "Mexico"}
        case .usa:
            return worldCupStore.fanfests.filter{$0.pais == "USA"}
        case .canada:
            return worldCupStore.fanfests.filter{$0.pais == "Canada"}
        }
    }
}

#Preview {
    FanFestList(showFanfests:.constant(false)).environmentObject(WorldCupStore())
}
