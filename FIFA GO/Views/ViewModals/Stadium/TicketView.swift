//
//  TicketView.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 09/10/25.
//

import SwiftUI

struct TicketView: View {
    @EnvironmentObject var worldCupStore: WorldCupStore

    let estadio: Estadio
    @State private var asiento: String = ""
    @State private var mostrarAcceso = false

    struct AccessResult {
        let gateID: String
        let isAccessible: Bool
        let isSeatFound: Bool
        /// Mensaje ya localizado (como String) usando NSLocalizedString + String.localizedStringWithFormat
        let message: String
    }

    // MARK: - Lógica de Acceso (Propiedad Computada)
    var accessInfo: AccessResult {

        // 1) Campo vacío
        if asiento.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return AccessResult(
                gateID: "",
                isAccessible: false,
                isSeatFound: false,
                message: NSLocalizedString("Enter your seat number to proceed", comment: "Empty input")
            )
        }

        // 2) Formato inválido
        guard let numero = Int(asiento) else {
            return AccessResult(
                gateID: "",
                isAccessible: false,
                isSeatFound: false,
                message: NSLocalizedString("Invalid seat format", comment: "Non-numeric seat")
            )
        }

        // 3) Estadio sin información
        guard let accesosDisponibles = estadio.accesos else {
            return AccessResult(
                gateID: "",
                isAccessible: false,
                isSeatFound: false,
                message: NSLocalizedString("Gate information is not available for this stadium", comment: "No data")
            )
        }

        // 4) Sección encontrada
        if let gate = accesosDisponibles.first(where: { $0.sections.contains(numero) }) {
            let fmt = NSLocalizedString("This seat belongs to section %d", comment: "Seat section found")
            return AccessResult(
                gateID: gate.id,
                isAccessible: gate.wheelchairAccessible,
                isSeatFound: true,
                message: String.localizedStringWithFormat(fmt, numero)
            )
        }

        // 5) Sección no mapeada
        let fmt = NSLocalizedString("Section %d is not mapped to an available access gate", comment: "Seat not mapped")
        return AccessResult(
            gateID: "",
            isAccessible: false,
            isSeatFound: false,
            message: String.localizedStringWithFormat(fmt, numero)
        )
    }

    var canFlip: Bool { accessInfo.isSeatFound }

    // MARK: - Body
    var body: some View {
        ZStack {
            if mostrarAcceso {
                reverso
                    // Mantén el contenido legible al girar
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                frente
            }
        }
        .frame(height: 220)
        .rotation3DEffect(.degrees(mostrarAcceso ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.8), value: mostrarAcceso)
        .onTapGesture {
            if canFlip {
                withAnimation { mostrarAcceso.toggle() }
            }
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(LocalizedStringKey(canFlip
            ? "Tap to reveal your Gate"
            : "Please check your section number"
        ))
    }

    // MARK: - Frente
    private var frente: some View {
        ZStack {
            TicketShape()
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.9), .indigo.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(radius: 8, x: 0, y: 5)
                .overlay(TicketShape().stroke(Color.white.opacity(0.3), lineWidth: 1))

            VStack(spacing: 12) {
                // "STADIUM: %@"
                let stadiumFmt = NSLocalizedString("STADIUM: %@", comment: "Ticket stadium label")
                Text(LocalizedStringKey(String.localizedStringWithFormat(stadiumFmt, estadio.nombre)))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(LocalizedStringKey("Your section"))
                    .font(.title2).bold()
                    .foregroundStyle(.white)

                TextField(LocalizedStringKey("Enter your seat section number"), text: $asiento)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(canFlip ? Color.green : Color.clear, lineWidth: canFlip ? 2 : 0)
                    )
                    .accessibilityLabel(LocalizedStringKey("Enter your seat section number"))

                Divider()
                    .frame(height: 0)
                    .overlay(
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(height: 1)
                    )
                    .padding(.horizontal, 30)

                Text(LocalizedStringKey(canFlip
                    ? "Tap to reveal your Gate"
                    : "Please check your section number"
                ))
                .font(.caption2)
                .foregroundStyle(canFlip ? .white.opacity(0.7) : .red.opacity(0.7))
            }
            .padding(30)
        }
        .padding(.horizontal)
    }

    // MARK: - Reverso
    private var reverso: some View {
        ZStack {
            TicketShape()
                .fill(
                    LinearGradient(
                        colors: [.orange.opacity(0.9), .red.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(radius: 8, x: 0, y: 5)
                .overlay(TicketShape().stroke(Color.white.opacity(0.3), lineWidth: 1))

            VStack(spacing: 15) {
                Text(LocalizedStringKey("Access Gate"))
                    .font(.headline)
                    .foregroundStyle(.white)

                // Gate + accesibilidad
                HStack(alignment: .center, spacing: 10) {
                    if accessInfo.isAccessible {
                        Image(systemName: "figure.roll.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue)
                            .accessibilityHidden(true)
                    }

                    // "Gate %@"
                    let gateFmt = NSLocalizedString("Gate %@", comment: "Gate label")
                    Text(LocalizedStringKey(String.localizedStringWithFormat(gateFmt, accessInfo.gateID)))
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .accessibilityLabel(LocalizedStringKey(String.localizedStringWithFormat(gateFmt, accessInfo.gateID)))

                    if accessInfo.isAccessible {
                        Image(systemName: "figure.roll.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue)
                            .accessibilityHidden(true)
                    }
                }
                .padding(.bottom, 5)

                Text(LocalizedStringKey(accessInfo.isAccessible
                                        ? "Wheelchair Accessible"
                                        : "Standard Access"))
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

                Text(LocalizedStringKey("Tap to return"))
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(30)
        }
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
