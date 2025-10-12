//
//  ItemTutorial.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 08/10/25.
//

import SwiftUI

struct ItemTutorial: View {
    let title:String
    let description:String
    let nameImage:String
    let color:Gradient
    @Environment(\.dynamicTypeSize) var dynamicTipe
    
    var body: some View {
        HStack{

            Image(systemName:nameImage)
                .font(.title2)
                .foregroundStyle(color)
                .bold()
            
            VStack(alignment: .leading,spacing: 5){
                Text(title)
                    .bold()
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text(description)
                    .font(.caption2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)
                
            }
            
            
            Spacer()
        }
        .padding(10)
        .glassEffect(in:.rect(cornerRadius: 20))
    }
}
