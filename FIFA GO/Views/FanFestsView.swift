//
//  FanFestsView.swift
//  FIFA GO
//
//  Created by Fatima Alonso on 10/3/25.
//

import SwiftUI

struct FanFestsView: View {
    @State private var selectedCountry: String = "USA"
    
    let countries = [
        ("Mexico", "🇲🇽"),
        ("USA", "🇺🇸"),
        ("Canada", "🇨🇦")
    ]
    
    let fanFests: [FanFest] = [
        FanFest(
            nombre: "Seattle Center",
            imagenAssetName: "seattlefan",
            ubicacion: Coordenada(lat: 47.6205, lon: -122.3493),
            horario: nil
            ),
        FanFest(
            nombre: "East Downtown",
            imagenAssetName: "houstonfanfest",
            ubicacion: Coordenada(lat: 47.6205, lon: -122.3493),
            horario: nil
            ),
        FanFest(
            nombre: "Centennial Olympic Park",
            imagenAssetName: "atlantafanfest",
            ubicacion: Coordenada(lat: 47.6205, lon: -122.3493),
            horario: nil
        ),
        FanFest(
            nombre: "Fair Park",
            imagenAssetName: "dallasfanfest",
            ubicacion: Coordenada(lat: 47.6205, lon: -122.3493),
            horario: nil
            ),
        FanFest(
            nombre: "National World War I Museum & Memorial",
            imagenAssetName: "kansascityfanfest",
            ubicacion: Coordenada(lat: 47.6205, lon: -122.3493),
            horario: nil
            ),
        FanFest(
            nombre: "Bayfront Park",
            imagenAssetName: "bayfrontpark",
            ubicacion: Coordenada(lat: 47.6205, lon: -122.3493),
            horario: nil
            ),
        FanFest(
            nombre: "Liberty State Park",
            imagenAssetName: "libertystate",
            ubicacion: Coordenada(lat: 47.6205, lon: -122.3493),
            horario: nil
            )
        ]
    
    @State private var selectedFest: FanFest? = nil
        
            
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("FIFA FAN FESTS")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                HStack(spacing: 16) {
                    ForEach(countries, id: \.0) { country, flag in
                        Button(action: {
                            selectedCountry = country
                        })    {
                            HStack(spacing: 6){
                                Text(flag)
                                Text(country)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(selectedCountry == country ? Color(.systemGray6) : Color.white)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    )
                            )
                        }
                        .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    ForEach(fanFests) { fest in
                        FanFestCard(fest: fest, isSelected: selectedFest?.id == fest.id
                        )
                        .onTapGesture {
                            withAnimation {
                                selectedFest = fest
                            }
                        }
                    }
                }
                
            
            
            }
        }
        
        
        
        
    }
}

struct FanFestCard: View {
    var fest: FanFest
    var isSelected: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let imageName = fest.imagenAssetName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                    )
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3
                    )
                        )
                            .overlay(
                                Text("No Image")
                                    .foregroundColor(.secondary)
                            )
            }
            
            VStack(spacing: 0) {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(colors:  [Color.black.opacity(0.5), Color.black.opacity(0.5)], startPoint: .bottom, endPoint: .top)
                        )
                    
                        .frame(height: 55)
                        .blur(radius: 2)
                }
            }
            Text(fest.nombre)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 12)
                .shadow(radius: 5)
               
                
        }
    }
}

#Preview {
    FanFestsView()
}
