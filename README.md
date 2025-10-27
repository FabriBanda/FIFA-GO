#  FAN GO ⚽️🌎

### Your all-in-one guide to the 2026 FIFA World Cup

FIFA GO is an inclusive and multilingual iOS app built with **SwiftUI** and **MapKit** that helps fans easily explore **stadiums, Fan Fests, accessible routes, and live translation features** during the 2026 FIFA World Cup across Mexico, the U.S., and Canada.

---

## Features

### Interactive Map 🗺️
- Explore **2026 World Cup stadiums** and **Fan Fests** directly on an interactive map.  
- Tap any location to see its details, photos, and real-time *Look Around* previews.  
- Supports **custom markers** with accessibility information.

### Accessibility First ♿️
- **VoiceOver** support across the app.  
- **Dynamic Type** for adaptable text sizes.  
- **Color contrast** compliant with WCAG 2.1 AA.  
- “Find My Gate” feature that shows accessible entrances based on your seat.

### Multilingual Experience 🌐
Available in **English, Spanish, French, and Portuguese**.  
The app automatically adapts to your iPhone’s language and region.

### Smart Ticket 🎟️ 
- Enter your seat number to locate your **section & gate**.  
- Detects if your gate supports **wheelchair access**.  
- Flip the ticket with an elegant 3D animation to reveal gate information.

### Live Translation 📸
Use your camera to translate any sign or printed text instantly — ideal for international fans.

### Guided Tutorial 💡
A built-in onboarding tutorial introduces new users to every feature and button in the app.

---

## Frameworks 

- **SwiftUI** — Declarative UI and dynamic layout  
- **MapKit / Look Around** — For stadiums and Fan Fest locations  
- **TipKit** — For contextual hints and onboarding  
- **AVFoundation / VoiceOver** — For accessibility and audio feedback  
- **Localization** — via `.strings` files in 4 languages  
- **UserDefaults** — To store onboarding progress  

---

## Architecture
- The app follows a clean **MVVM + EnvironmentObject** structure for scalability and modularity.
---

## Getting Started

### Prerequisites
- macOS Sequoia or later  
- Xcode 16 or later  
- iPhone Simulator or physical device running **iOS 18+**

### Run the project
```bash
git clone https://github.com/FabriBanda/FIFA-GO.git
cd "FIFA GO"
open "FIFA GO.xcodeproj"
