//
//  TIcketView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 09/10/25.
//

import SwiftUI

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
                    Text(LocalizedStringKey("Search Gate"))
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
