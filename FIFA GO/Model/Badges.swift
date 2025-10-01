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
    var backgroundColor:Color
    var type:ModalRoute
}



#if DEBUG

var badges = [
 
    Badge(imageName: "translate", backgroundColor: Color.indigo,type: .traductor),
    Badge(imageName: "sportscourt.fill", backgroundColor: .blue,type:.estadioList),
    Badge(imageName: "party.popper.fill", backgroundColor: .cyan,type:.fanFestList)
    
]

#endif
