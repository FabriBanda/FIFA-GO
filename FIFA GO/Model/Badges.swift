//
//  Badges.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 30/09/25.
//

import Foundation
import SwiftUI

struct Badge:Identifiable {
    var id = UUID()
    var imageName:String
    var backgroundColor:Gradient
    var type:ModalRoute
}



#if DEBUG

var badges = [
 
    Badge(imageName: "translate", backgroundColor:Gradient(colors: [Color.colorTranslate]),type: .traductor),
    Badge(imageName: "sportscourt.fill", backgroundColor:Gradient(colors: [Color.colorEstadio]),type:.estadioList),
    Badge(
        imageName: "party.popper.fill",
        backgroundColor: Gradient(colors: [
            Color(cgColor: CGColor(red: 170/255, green: 75/255, blue: 107/255, alpha: 1)),   // #aa4b6b
            Color(cgColor: CGColor(red: 107/255, green: 107/255, blue: 131/255, alpha: 1)),  // #6b6b83
            Color(cgColor: CGColor(red: 59/255, green: 141/255, blue: 153/255, alpha: 1))    // #3b8d99
        ]),
        type: .fanFestList
    )
    
]

#endif
