//
//  TIcketView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 09/10/25.
//

import SwiftUI

struct TicketView: View {
    @EnvironmentObject var worldCupStore: WorldCupStore
    
    let estadio: Estadio // el estadio donde se va a buscar el acceso
    @State private var asiento: String = ""
    @State private var mostrarAcceso = false
    
    // Define un tipo de resultado para agrupar toda la información de acceso
    struct AccessResult {
        let gateID: String
        let isAccessible: Bool
        let isSeatFound: Bool
        let message: String
    }
    
    // MARK: - Lógica de Acceso (Propiedad Computada)
    var accessInfo: AccessResult {
        
        // 1. Asiento no ingresado (Estado inicial)
        guard !asiento.isEmpty else {
            return AccessResult(gateID: "", isAccessible: false, isSeatFound: false, message: "Enter your seat number to proceed.")
        }
        
        // 2. Asiento no es un número válido
        guard let numero = Int(asiento) else {
            return AccessResult(gateID: "", isAccessible: false, isSeatFound: false, message: "Invalid seat format.")
        }
        
        // 3. Información de acceso del estadio no disponible
        guard let accesosDisponibles = estadio.accesos else {
            return AccessResult(gateID: "", isAccessible: false, isSeatFound: false, message: "Gate information is not available for this stadium.")
        }
        
        // 4. Buscar el Gate correspondiente
        if let gate = accesosDisponibles.first(where: { $0.sections.contains(numero) }) {
            return AccessResult(
                gateID: gate.id,
                isAccessible: gate.wheelchairAccessible,
                isSeatFound: true,
                message: "This seat belongs to section \(numero)."
            )
        } else {
            // 5. Asiento fuera de rango (No encontrado en ninguna sección)
            return AccessResult(gateID: "", isAccessible: false, isSeatFound: false, message: "Section \(numero) is not mapped to an available access gate.")
        }
    }
    
    // Propiedad para determinar si el boleto puede girarse
    var canFlip: Bool {
        return accessInfo.isSeatFound // Solo se gira si se encontró la sección
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            // Usa .rotation3DEffect en el ZStack para aplicar la animación de giro
            // La cara del reverso tiene una rotación inicial de 180 para que mire hacia atrás
            if mostrarAcceso {
                reverso
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                frente
            }
        }
        .frame(height: 220) // Aumento de altura para mejor UI
        .rotation3DEffect(.degrees(mostrarAcceso ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.8), value: mostrarAcceso)
        .onTapGesture {
            if canFlip { // Solo permite girar si canFlip es true
                withAnimation { mostrarAcceso.toggle() }
            }
        }
    }
    
    // ---
    // MARK: - Frente
    private var frente: some View {
        ZStack {
            TicketShape()
                .fill(
                    LinearGradient(colors: [.blue.opacity(0.9), .indigo.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing)
                )
                .shadow(radius: 8, x: 0, y: 5) // Sombra más pronunciada
                .overlay(TicketShape().stroke(Color.white.opacity(0.3), lineWidth: 1)) // Borde sutil
                
            VStack(spacing: 12) {
                Text("ESTADIO: \(estadio.nombre)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.8))
                
                Text("Your Ticket")
                    .font(.title2).bold()
                    .foregroundStyle(.white)
                
                TextField("Enter your seat section number", text: $asiento)
                    .keyboardType(.numberPad)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(canFlip ? Color.green : Color.clear, lineWidth: canFlip ? 2 : 0) // Indicador visual
                    )
                
                Divider()
                    .frame(height: 0)
                    .overlay(
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(height: 1)
                    )
                    .padding(.horizontal, 30)
                
                Text(canFlip ? "Tap to reveal your Gate" : "Please check your section number.")
                    .font(.caption2)
                    .foregroundStyle(canFlip ? .white.opacity(0.7) : .red.opacity(0.7))
            }
            .padding(30)
        }
        .padding(.horizontal)
    }

    // ---
    // MARK: - Reverso
    private var reverso: some View {
        ZStack {
            TicketShape()
                .fill(
                    LinearGradient(colors: [.orange.opacity(0.9), .red.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing)
                )
                .shadow(radius: 8, x: 0, y: 5)
                .overlay(TicketShape().stroke(Color.white.opacity(0.3), lineWidth: 1))
            
            VStack(spacing: 15) {
                Text("Access Gate")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                // Icono de accesibilidad
                HStack(alignment: .center, spacing: 10) {
                    if accessInfo.isAccessible {
                        Image(systemName: "figure.roll.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue)
                    }
                    
                    Text("Gate \(accessInfo.gateID)")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    
                    if accessInfo.isAccessible {
                        Image(systemName: "figure.roll.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue)
                    }
                }
                .padding(.bottom, 5)
                
                Text(accessInfo.isAccessible ? "Wheelchair Accessible" : "Standard Access")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                
                Divider()
                    .frame(height: 0)
                    .overlay(
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(height: 1)
                    )
                    .padding(.horizontal, 30)
                
                Text("Tap to return")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(30)
        }
        // Este .rotation3DEffect es crucial para que el contenido aparezca derecho
        // cuando la tarjeta principal está girada 180 grados.
        // Se aplicó en el ZStack de la vista principal.
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
