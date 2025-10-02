//
//  StadiumDetail.swift
//  FIFA GO
//
//  Created by Fabricio Banda on 01/10/25.
//

import SwiftUI

struct StadiumDetail: View {
    
    
    @State private var showTicket:Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    let estadio:Estadio
    
    
    
    var body: some View {
        NavigationStack {
            
            VStack{
                Text(estadio.nombre)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.primary)
                
                Text("Stadium")
                
//                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 5)
                        .frame(width: 350,height: 200)
                        .padding(.bottom,8)
//                }
                
                HStack(spacing: 15){
                    Button{
                        
                    }label:{
                        HStack{
                            Image(systemName: "location.fill")
                                .foregroundColor(.green)
                                .bold()
                            
                            Text("Open in Maps")
                           
                        }
                    }.buttonStyle(.glass)
                    
                    Button{
                        withAnimation {
                            showTicket.toggle()
                        }
                    }label:{
                        HStack{
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.red)
                                .bold()
                            
                            Text("Find My Gate")
                           
                        }
                    }.buttonStyle(.glass)
                }
                
                if showTicket{
                   TicketView()
                }
                
                VStack{
                    Text("Matches Today")
                        .font(.title3)
                        .bold()
                    
                    Divider()
               
                    MatchView(partido: Partido(equipo1: Equipo(nombre: "Mexico", bandera: "🇲🇽"), equipo2:Equipo(nombre: "Canada", bandera: "🇨🇦"), inicio: Date.now, estadioID: estadio.id))
                    
                }.padding(.top)
              
               
                
                Spacer()
            }.padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            dismiss()
                        }label:{
                            Image(systemName: "xmark")
                                .bold()
                        }
                    }
                }
        }
 
    }
    
}

struct TicketView:View {
    var body: some View {
        VStack{
            Image("ticket")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
            Button{
                
            }label:{
                HStack{
                    Spacer()
                    Text("Search Gate")
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                
            }
             .buttonStyle(.glassProminent)
             .padding(.horizontal,40)
             
        }
    }
}


struct MatchView:View {
    let partido:Partido
    var body: some View {
        VStack{
            
            HStack{
                Spacer()
                Text(partido.equipo1.bandera+partido.equipo1.nombre)
                    .font(.title3)
                    .bold()
                Spacer()
                Text(partido.equipo2.nombre+partido.equipo2.bandera)
                    .font(.title3)
                    .bold()
                Spacer()
            }
            
            Text("11:00 am")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}
