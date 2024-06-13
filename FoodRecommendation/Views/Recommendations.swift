//
//  RecommendationService.swift
//  ProjectRecommenderTrial
//
//  Created by Baghiz on 05/06/24.
//

import SwiftUI

struct Recommendations<Model>: View where Model: TextImageProvider & Hashable & Identifiable {
    let recommendations: [Model]
    
    var body: some View {
        VStack {
            HStack {
                Text("Recommendations")
                    .fontWeight(.bold)
                    .font(.system(size:24))
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.6))
                Spacer()
            }
            .padding(.horizontal)
            
            if !recommendations.isEmpty {
                VStack {
                    Spacer()
                    
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .center, spacing: 12.0) {
                          ForEach(recommendations) { item in
                            SmallCard(model: item)
                          }
                        }
                        .padding(.horizontal)
                    
                    Spacer()
                    }
                }
                
            } else {
                HStack {
                  Spacer()

                  VStack {
                      Spacer()
                      
                    Image("notfound")
                          .resizable()
                          .imageScale(.large)
                          .frame(width: 100, height: 100)

                    Text("Nothing yet!")
                          .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.6))
                          .fontWeight(.semibold)
                      .multilineTextAlignment(.center)
                      .font(.callout)
                      
                      Spacer()
                  }
                  .foregroundColor(.secondary)

                  Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 32)
              }
            
        }
    }
}

struct Recommendations_Previews: PreviewProvider {
    static var previews: some View {
        Recommendations(
            recommendations: [Food.origin]
        )
    }
}
