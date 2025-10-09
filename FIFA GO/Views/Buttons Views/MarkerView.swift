//
//  MarkerView.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 01/10/25.
//

import SwiftUI

struct MarkerView: View {
    @Environment(\.colorScheme) var colorScheme
    let imageName:String
    let colorBackground:Color
    let color:Color
    var body: some View {
        
//        Image(colorScheme == .dark ? "worldcupDark":"worldcup")
//            .resizable()
//            .scaledToFit()
//            .frame(width: 80)
        
        Image(systemName: imageName)
            .font(.largeTitle)
            .foregroundStyle(color)
            .padding(5)
            .background(colorBackground,in:Circle())
        
    }
    
}

#Preview {
    MarkerView(imageName: "soccerball.inverse",colorBackground: Color.green,color:.black)
}
