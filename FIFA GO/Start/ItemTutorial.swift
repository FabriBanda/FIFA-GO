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
    let backgroundColor:Color
    
    var body: some View {
        HStack{
            Image(systemName: "hexagon.fill")
                .font(.system(size: 45))
                .foregroundStyle(backgroundColor)
                .overlay {
                    Image(systemName:nameImage)
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .bold()
                }
                .padding(3)
            
            VStack(alignment: .leading,spacing: 5){
                Text(title)
                    .bold()
                    .font(.headline)
                
                Text(description)
                    .font(.caption2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
                
            }
            
            
            Spacer()
        }
        .padding(10)
        .glassEffect(in:.rect(cornerRadius: 20))
    }
}
