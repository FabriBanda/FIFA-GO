//
//  Tips.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 30/09/25.
//

import Foundation
import TipKit

struct TipUno:Tip{
    var title: Text{
        Text("Abrir menu de opciones")
    }
    var message: Text?{
        Text("Presiona para ver el menu de opciones")
    }
    var image: Image?{
        Image(systemName: "lightbulb.max.fill")
          
    }
}
