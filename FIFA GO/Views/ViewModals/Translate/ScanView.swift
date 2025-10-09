//
//  ScanView.swift
//
import SwiftUI
import VisionKit
import Combine

struct ScanView: UIViewControllerRepresentable {
    // Es mejor usar @Binding si ScanProvider se crea y observa en TraductorView,
    // pero para mantener tu estructura original, lo dejaremos como @ObservedObject.
    @ObservedObject var scanProvider: ScanProvider
     
    func makeUIViewController(context: Context) -> DataScannerViewController {
        // Reconocimiento solo de texto, nivel de calidad rápido
        let dataScannerViewController = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .fast,
            isHighlightingEnabled: true
        )
         
        dataScannerViewController.delegate = scanProvider
         
        try? dataScannerViewController.startScanning()
        return dataScannerViewController
    }
     
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

// Clase que maneja el escaneo y publica el texto.
final class ScanProvider: NSObject, DataScannerViewControllerDelegate, ObservableObject {
    @Published var text : String = ""
    @Published var error : DataScannerViewController.ScanningUnavailable?
     
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let recogizedText):
            
            let originalText = recogizedText.transcript
            
            
            let cleanedTextStep1 = originalText.replacingOccurrences(of: "\n", with: " ")
                                              
            let cleanedTextStep2 = cleanedTextStep1.replacingOccurrences(of: "\r", with: " ")
            
            let finalCleanText = cleanedTextStep2.replacingOccurrences(of: " +", with: " ", options: .regularExpression)
            
            self.text = finalCleanText
            print("Texto Escaneado Limpio: \(self.text)")
            
        case .barcode(_):
            break
        @unknown default :
            break
        }
    }
     
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        print("Error de escaneo: \(error)")
        self.error = error
    }
}
