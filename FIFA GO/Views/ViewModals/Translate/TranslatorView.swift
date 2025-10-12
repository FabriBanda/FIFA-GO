import SwiftUI
import Translation

struct TraductorView: View {
    @StateObject var scanProvider = ScanProvider()  
    @State private var isTranslatingShowing = false
    
    var body: some View {
        VStack {
            ScanView(scanProvider: scanProvider)
                .frame(height: 600)
                .cornerRadius(20)
                .padding()
            
            Text(scanProvider.text.isEmpty ? String(localized: "Scan something to get started…") : scanProvider.text)
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)
                .translationPresentation(isPresented: $isTranslatingShowing, text: scanProvider.text)
            Button{
                isTranslatingShowing.toggle()
            } label:{
                Text(LocalizedStringKey("Translate"))
            }
        }
    }
}

#Preview {
    TraductorView()
}
