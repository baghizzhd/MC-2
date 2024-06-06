//
//  StartPage.swift
//  NC1-felicia
//
//  Created by Felicia Graciella on 09/05/23.
//

import SwiftUI

struct StartPage: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
               
                NavigationLink(destination: SwipePage(), label: {
                    Text("Let's eat")
                        .fontWeight(.bold)
                        .frame(width: 280, height: 48)
                        .buttonStyle(.bordered)
                        .background(Color.sbred)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                })
                
                Text("Instruction")
                    .fontWeight(.bold)
                    .frame(width: 280, height: 48)
                    .buttonStyle(.bordered)
                    .background(Color.sbred)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bg)
    }
}

struct StartPage_Previews: PreviewProvider {
    static var previews: some View {
        StartPage()
    }
}
