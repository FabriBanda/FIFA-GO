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
    let colorBackground:Gradient
    let color:Gradient
    var body: some View {
        
        Image(systemName: imageName)
            .font(.largeTitle)
            .foregroundStyle(color)
            .padding(5)
            .background(colorBackground,in:Circle())
        
    }
    
}
