//
//  StadiumsList.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 01/10/25.
//

import SwiftUI
import MapKit

struct StadiumsList: View {
    @Binding var cameraPosition: MapCameraPosition
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button{
            withAnimation {
                dismiss()
                cameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.67119328280499, longitude: -100.24416690079325), latitudinalMeters: 900, longitudinalMeters: 900))
            }
           
        }label:{
            Text("Ir a estadio")
        }
    }
}
