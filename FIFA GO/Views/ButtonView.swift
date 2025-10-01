//
//  ButtonView.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 30/09/25.
//

import SwiftUI

struct ButtonView: View {

    let badge : Badge
    
    var body: some View {

            Image(systemName: "hexagon.fill")
                .font(.system(size: 45))
                .foregroundStyle(badge.backgroundColor)
                .overlay {
                    Image(systemName: badge.imageName)
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .bold()
                }
        
        .padding(3)
        .glassEffect(.regular.interactive(),in:.rect(cornerRadius: 15))
            
    }
}

#Preview {
    ButtonView(badge: badges[0])
}
