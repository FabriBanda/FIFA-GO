//
//  TranslatorView.swift
//  FIFA GO
//
//  Created by Biniza Ruiz on 07/10/25.
//

import SwiftUI

struct TraductorView: View {
    @StateObject var scanProvider = ScanProvider()
    var body: some View {
        ScanView(scanProvider: scanProvider)
        //Text("Hola")
    }
}

#Preview {
    TraductorView()
}
