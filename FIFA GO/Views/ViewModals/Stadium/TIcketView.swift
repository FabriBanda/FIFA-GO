//
//  TIcketView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 09/10/25.
//

import SwiftUI

struct TicketView: View {
    @EnvironmentObject var worldCupStore: WorldCupStore
    
    let estadio: Estadio   // el estadio donde se va a buscar el acceso
    @State private var asiento: String = ""
    @State private var mostrarAcceso = false
    
    var acceso: String {
        guard let numero = Int(asiento) else { return "Gate not available" }
        
        guard let accesosDisponibles = estadio.accesos else {
            return "Gate info not available for this stadium" // Mensaje más preciso
        }
        
        if let gate = accesosDisponibles.first(where: { $0.sections.contains(numero) }) {
            return "Gate \(gate.id)"
        } else {
            return "Gate not available for section \(numero)"
        }
    }

    var body: some View {
        ZStack {
            if mostrarAcceso {
                reverso
            } else {
                frente
            }
        }
        .frame(height: 200)
        .rotation3DEffect(.degrees(mostrarAcceso ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.8), value: mostrarAcceso)
        .onTapGesture {
            withAnimation { mostrarAcceso.toggle() }
        }
    }
    
    // MARK: - Frente
    private var frente: some View {
        ZStack {
            TicketShape()
                .fill(
                    LinearGradient(colors: [.blue.opacity(0.9), .indigo.opacity(0.8)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .shadow(radius: 4)
            
            VStack(spacing: 12) {
                Text("Your Ticket")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                TextField("Enter your seat number", text: $asiento)
                    .keyboardType(.numberPad)
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Divider()
                    .overlay(Color.white.opacity(0.6))
                    .blendMode(.overlay)
                    .padding(.horizontal, 30)
                    .overlay(
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.horizontal, 30)
                    )
                
                Text("Tap to flip and see your gate")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
        }
        .padding(.horizontal)
    }

    // MARK: - Reverso
    private var reverso: some View {
        ZStack {
            TicketShape()
                .fill(
                    LinearGradient(colors: [.orange.opacity(0.9), .red.opacity(0.8)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .shadow(radius: 4)
            
            VStack(spacing: 12) {
                Text("Access Information")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                
                Divider()
                    .overlay(Color.white.opacity(0.6))
                    .blendMode(.overlay)
                    .padding(.horizontal, 30)
                    .overlay(
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.horizontal, 30)
                    )
                
                Text(acceso)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                
                Text("Tap to return")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
        }
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .padding(.horizontal)
    }
}


// MARK: - Forma personalizada del boleto
struct TicketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let notchRadius: CGFloat = 12 // radio del recorte lateral
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY - notchRadius))
        path.addArc(center: CGPoint(x: rect.maxX, y: rect.midY),
                    radius: notchRadius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.midY + notchRadius))
        path.addArc(center: CGPoint(x: 0, y: rect.midY),
                    radius: notchRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(270),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: 0))
        return path
    }
}
