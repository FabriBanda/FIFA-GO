//
//  RowList.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 09/10/25.
//


import SwiftUI
import MapKit

struct RowList: View {
    
    let name:String
    let imageName: String
    

    var body: some View {
        ZStack {
            Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
           
        }
        .overlay(alignment: .bottom) {
            HStack {
                Spacer()
                Text(name)
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
