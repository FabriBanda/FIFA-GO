//
//  ScanView.swift
//  FIFA GO
//
//  Created by Biniza Ruiz on 07/10/25.
//

import SwiftUI
import VisionKit
import Combine

struct ScanView: UIViewControllerRepresentable {
    @ObservedObject var scanProvider = ScanProvider()
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.text()], qualityLevel: .fast, isHighlightingEnabled: true)
        
        dataScannerViewController.delegate = scanProvider
        
        //Inicie inmediatamente la camara
        try? dataScannerViewController.startScanning()
        return dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

final class ScanProvider: NSObject, DataScannerViewControllerDelegate, ObservableObject {
    @Published var text : String = ""
    @Published var error : DataScannerViewController.ScanningUnavailable?
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let recogizedText):
            self.text = recogizedText.transcript
            print(recogizedText)
        case .barcode(_):
            break
        @unknown default :
            break
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        print(error)
    }
    
}
