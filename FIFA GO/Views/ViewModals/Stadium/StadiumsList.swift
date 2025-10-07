//
//  StadiumsList.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 01/10/25.
//

import SwiftUI
import MapKit

struct StadiumsList: View {
    @State private var searchText:String = ""
    @EnvironmentObject var worldCupStore:WorldCupStore
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            VStack{
                
                HStack{
                
                    Spacer()
                    PaisButtonFilter(pais: "🇲🇽Mexico")
                    Spacer()
                    PaisButtonFilter(pais: "🇺🇸USA")
                    Spacer()
                    PaisButtonFilter(pais: "🇨🇦Canada")
                    Spacer()
                }
                List{
                    ForEach(worldCupStore.estadios.filter{searchText.isEmpty ? true : $0.nombre.contains(searchText)}){ estadio in
                        EstadioView(estadio: estadio)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                withAnimation {
                                    dismiss()
                                    worldCupStore.cameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: estadio.ubicacion.lat, longitude: estadio.ubicacion.lon), latitudinalMeters: 1000, longitudinalMeters: 1000))
                                    
                                }
                            }
                    }
                }.listStyle(.plain)
                
            }.navigationTitle("Stadiums")
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
                .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search Stadiums")
        }
    }
}

struct PaisButtonFilter:View {
    let pais:String
    var body: some View {
        
        Button {
            withAnimation {
                
            }
        } label: {
            Text(pais)
                .foregroundStyle(.primary)
                .font(.headline)
        }.buttonStyle(.glass)

    }
}

struct EstadioView:View {
    let estadio : Estadio
    var body: some View {
        Image(estadio.imagenAssetName)
            .resizable()
            .scaledToFit()
            .overlay {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text(estadio.nombre)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .bold()
                        Spacer()
                    }
                    .padding(.vertical,10)
                    .background(Color.black.opacity(0.5))
                     
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    StadiumsList().environmentObject(WorldCupStore())
}
