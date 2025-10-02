//
//  ButtonToggle.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 30/09/25.
//

import SwiftUI

struct ButtonToggle: View {
    
    @Binding var show:Bool
    var body: some View {

            Image(systemName: show ? "xmark":"square.grid.2x2.fill")
                .font(.largeTitle)
                .foregroundStyle(.primary)

        .padding(8)
        .glassEffect(.regular.interactive(),in:.rect(cornerRadius: 15))
        .onTapGesture {
            withAnimation {
                show.toggle()
            }
      
        }
    }
}

#Preview {
    ButtonToggle(show: .constant(false))
}
