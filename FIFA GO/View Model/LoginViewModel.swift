//
//  LoginViewModel.swift
//  FIFA GO
//
//  Created by Fabricio Banda Hernandez on 09/10/25.
//

import Foundation
import Combine

final class Login:ObservableObject{
    init(){
        UserDefaults.standard.register(defaults: [
            "app.login.hasSeenMapView":false
        ])
    }
    
    @Published var hasSeenMapView : Bool = UserDefaults.standard.bool(forKey: "app.login.hasSeenMapView"){
        didSet{
            UserDefaults.standard.setValue(hasSeenMapView, forKey: "app.login.hasSeenMapView")
        }
    }
}
