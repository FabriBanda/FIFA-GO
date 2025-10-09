import SwiftUI
import Translation

struct TraductorView: View {
    @StateObject var scanProvider = ScanProvider()  // Observa el texto publicado desde ScanProvider
    @State private var isTranslatingShowing = false
    
    var body: some View {
        VStack {
            ScanView(scanProvider: scanProvider)
                .frame(height: 600)
                .cornerRadius(20)
                .padding()
            
            Text(scanProvider.text.isEmpty ? "Escanea algo para empezar..." : scanProvider.text)
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)
                .translationPresentation(isPresented: $isTranslatingShowing, text: scanProvider.text)
            Button{
                isTranslatingShowing.toggle()
            } label:{
                Text("Translate")
            }
        }
    }
}

#Preview {
    TraductorView()
}
