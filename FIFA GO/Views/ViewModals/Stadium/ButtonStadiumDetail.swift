//
//  ButtonStadiumDetail.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 10/10/25.
//

import SwiftUI

struct ButtonStadiumDetail: View {
    
    let nameImage:String
    let text:String
    let color:Color
    
    var body: some View {
    
            HStack {
               
                Image(systemName:nameImage)
                    .foregroundColor(color)
                    .bold()
                
                Text(LocalizedStringKey(text))
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }.padding(.vertical,8)
    }
}


