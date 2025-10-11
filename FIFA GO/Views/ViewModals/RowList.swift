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
    @Environment(\.dynamicTypeSize) var dynamicType

    var body: some View {
        ZStack {
            Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: dynamicType == .accessibility5 || dynamicType == .accessibility4 ? 220:160)
                    .clipped()
           
        }
        .overlay(alignment: .bottom) {
            HStack {
                Spacer()
                Text(name)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
            }
            .padding(.vertical, 8)
            .background(.black.opacity(0.45))
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}
