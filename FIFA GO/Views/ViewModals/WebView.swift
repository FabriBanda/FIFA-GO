//
//  WebView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 06/10/25.
//

import SwiftUI
import WebKit

struct WebApi: View {
    @Environment(\.dismiss) var dismiss
    let url:String
    var body: some View {
        NavigationStack {
            
            WebView(url:URL(string: url)
            )
            .ignoresSafeArea()
            .toolbar {
                Button{
                    dismiss()
                }label:{
                    Image(systemName:"xmark")
                        .font(.headline)
                     
                }
            }
        }
    }
}


