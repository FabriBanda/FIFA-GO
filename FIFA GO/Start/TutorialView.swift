import SwiftUI

struct TutorialView: View {
    @State private var showMap = false
    @EnvironmentObject var worldCupStore: WorldCupStore
    @StateObject var login = Login()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 13) {
                Spacer()
                
                Text(String(localized: "tutorial.title", defaultValue: "Your Guide to\nFIFA GO"))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()
                
                ItemTutorial(
                    title: String(localized: "tutorial.live.translation.title", defaultValue: "Live Translation"),
                    description: String(localized: "tutorial.live.translation.description", defaultValue: "Point your camera at any text and get an instant translation into your preferred language."),
                    nameImage: "translate",
                    color: Gradient(colors: [.colorTranslate])
                )
                
                ItemTutorial(
                    title: String(localized: "tutorial.stadiums.title", defaultValue: "World Cup Stadiums"),
                    description: String(localized: "tutorial.stadiums.description", defaultValue: "Browse all 2026 World Cup stadiums. Filter by country or name, and tap to see each on the map."),
                    nameImage: "sportscourt.fill",
                    color:Gradient(colors: [.green])
                )
                
                ItemTutorial(
                    title: String(localized: "tutorial.fanfests.title", defaultValue: "Fan Fests"),
                    description: String(localized: "tutorial.fanfests.description", defaultValue: "Browse World Cup Fan Fests. Tap any one to see its exact location on the map and find your way there."),
                    nameImage: "party.popper.fill",
                    color:Gradient(colors: [
                        Color.togglefanfest
                    ])
                )
                
                ItemTutorial(
                    title: String(localized: "tutorial.stadium.marker.title", defaultValue: "Stadium Marker"),
                    description: String(localized: "tutorial.stadium.marker.description", defaultValue: "Explore 2026 stadiums by country or name, and view any location on the map."),
                    nameImage: "soccerball.inverse",
                    color: Gradient(colors: [Color.primary])
                )
                
                ItemTutorial(
                    title: String(localized: "tutorial.fanfest.marker.title", defaultValue: "Fan Fest Marker"),
                    description: String(localized: "tutorial.fanfest.marker.description", defaultValue: "Tap a Fan Fest pin to see Look Around, live screenings, and events."),
                    nameImage: "party.popper.fill",
                    color:Gradient(colors: [Color.red,Color.blue,Color.green]))
                
                ItemTutorial(
                    title: String(localized: "tutorial.location.title", defaultValue: "My Location"),
                    description: String(localized: "tutorial.location.description", defaultValue: "Tap to center the map on your current location"),
                    nameImage: "location.circle.fill",
                    color:Gradient(colors: [.blue])
                )
                
                Button {
                    showMap = true
                    login.hasSeenMapView = true
                } label: {
                    ContinueButton()
                }
                .padding(.vertical)
                .buttonStyle(.plain)
                .tint(.blue)
            }
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $showMap) {
            MapView()
                .environmentObject(worldCupStore)
        }
    }
}

#Preview {
    TutorialView().environmentObject(WorldCupStore())
}
