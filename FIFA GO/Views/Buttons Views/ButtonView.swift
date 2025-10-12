//
//  ButtonView.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 30/09/25.
//

import SwiftUI

struct ButtonView: View {

    let badge : Badge
    @Environment(\.dynamicTypeSize) var dynamicType
    var body: some View {

            Image(systemName: "hexagon.fill")
            .font(dynamicType.showExpandView ? .system(size: 65):.largeTitle)
                .foregroundStyle(badge.backgroundColor)
                .overlay {
                    Image(systemName: badge.imageName)
                        .font(dynamicType.showExpandView ? .system(size: 30):.title3)
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
