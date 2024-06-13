//
//  RecommendationService.swift
//  ProjectRecommenderTrial
//
//  Created by Baghiz on 05/06/24.
//

import SwiftUI

struct SmallCard<Model>: View where Model: TextImageProvider {
    let model: Model
    
    var body: some View {
        ZStack {
            Group {
                  if let image = model.image {
                    Image(uiImage: image)
                      .resizable()
                  } else {
                    Color(uiColor: .systemFill)
                  }
            }
            .aspectRatio(contentMode: .fill)
            .frame(
              width: 120,
              height: 150,
              alignment: .center
            )
            
            .clipped()
            
            VStack {
                Spacer()
                Text(model.name)
                    .shadow(radius: 5)
                    .font(.system(size:16))
                    .fontWeight(.bold)
                    .padding([.leading, .bottom], 8)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(
                      width: 120,
                      alignment: .leading)
            }
        }
        .frame(
          width: 120,
          height: 150
        )
        .cornerRadius(10)
    }
}

struct SmallCard_Previews: PreviewProvider {
    static var previews: some View {
        SmallCard(model: Food.origin)
    }
}
