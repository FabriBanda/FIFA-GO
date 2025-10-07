//
//  StadiumsList.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 01/10/25.
//

import SwiftUI
import MapKit

struct Stadium: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let imageName: String
}

struct StadiumsList: View {
    
    @Binding var cameraPosition: MapCameraPosition
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    @State private var selectedCountry: String? = nil
    
    let countries = ["🇲🇽 Mexico", "🇺🇸 USA", "🇨🇦 Canada"]
    let stadiums = [
        Stadium(name: "Estadio Azteca", country: "🇲🇽 Mexico", imageName: "azteca"),
        Stadium(name: "BBVA", country: "🇲🇽 Mexico", imageName: "bbva"),
        Stadium(name: "Estadio Akron", country: "🇲🇽 Mexico", imageName: "akron"),
        Stadium(name: "Hardrock", country: "🇺🇸 USA", imageName: "HardRock"),
        Stadium(name: "BMO", country: "🇨🇦 Canada", imageName: "BMO")
    ]
    
        var filteredStadiums: [Stadium] {
            if searchText.isEmpty {
                // Si no hay texto en el buscador, aplica el filtro por país
                return stadiums.filter { stadium in
                    selectedCountry == nil || stadium.country == selectedCountry
                }
            } else {
                // Si hay texto en el buscador, ignora el filtro por país
                return stadiums.filter { stadium in
                    stadium.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    

    var body: some View {
        ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Stadiums")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search Stadium", text: $searchText)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Country buttons
                        HStack(spacing: 12) {
                            ForEach(countries, id: \.self) { country in
                                Button(action: {
                                    if selectedCountry == country {
                                        selectedCountry = nil
                                    } else {
                                        selectedCountry = country
                                    }
                                }) {
                                    HStack {
                                        Text(country)
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedCountry == country ? Color.black : Color.white)
                                    .foregroundColor(selectedCountry == country ? .white : .black)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        
                        // Stadium list
                        VStack(spacing: 20) {
                            ForEach(filteredStadiums) { stadium in
                                ZStack(alignment: .bottomLeading) {
                                    Image(stadium.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 180)
                                        .cornerRadius(16)
                                        .clipped()
                                    Text(stadium.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .shadow(radius: 4)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
                .background(Color.white.ignoresSafeArea())
    }
}
