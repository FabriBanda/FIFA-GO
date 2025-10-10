//
//  ContinueButton.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 09/10/25.
//

import SwiftUI

struct ContinueButton: View {
    var body: some View {
        HStack{
         
            Image(systemName: "arrowshape.forward.circle.fill")
                .font(.title)
            
            Text("Continue")
                .font(.subheadline)
          
        }
        .foregroundStyle(.white)
        .bold()
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .glassEffect(.regular.tint(Color.blue))
    }
}

#Preview {
    ContinueButton()
}
