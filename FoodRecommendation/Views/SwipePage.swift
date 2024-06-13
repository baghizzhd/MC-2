//
//  RecommendationService.swift
//  ProjectRecommenderTrial
//
//  Created by Baghiz on 05/06/24.
//

import SwiftUI

struct SwipePage: View {
    @State var info = false
    @StateObject private var viewModel: MainModel

    init() {
      _viewModel = StateObject(wrappedValue: MainModel())
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Swipe!")
                    .fontWeight(.bold)
                    .font(.system(size:24))
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.6))
                Spacer()
                
                Button{
                    info = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.6))
                        .padding(4)
                        .sheet(isPresented: $info, content: {
                            Information()
                                
                    })
                    
                }
                .zIndex(1)
                
                
            }
            .padding(.bottom, -10)
            .padding(.top, 16)
            .padding(.horizontal,30)
            
                
            if viewModel.foods.isEmpty {
              HStack {
                Spacer()

                VStack {
                    Spacer()
                    
                      Text("All Done!")
                        .multilineTextAlignment(.center)
                        .font(.callout)
                        .foregroundColor(Color.sborange)
                      Button("Try Again") {
                        withAnimation {
                          viewModel.resetUserChoices()
                        }
                      }
                      .font(.headline)
                      .tint(Color.sborange)
                      .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }

                Spacer()
              }
              .padding(.horizontal)
              .padding(.vertical, 32)
            } else {
                
                Swipe(models: viewModel.foods) { item, isLiked in
                    withAnimation(.spring()) {
                        viewModel.didRemove(item, isLiked: isLiked)
                    }
                }
                .padding(.top, 10)
            }
            
            Spacer()
            
            Recommendations(recommendations: viewModel.recommendations)
                .padding([.horizontal, .bottom])
                .padding(.top, 20)
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadAllFoods()
        }
    }
}


struct Swipe<Model>: View where Model: TextImageProvider & Hashable {
    let models: [Model]
    let onRemove: (_ model: Model, _ isLiked: Bool) -> Void
    
    
    var body: some View {
        HStack {
            Spacer()
            
            GeometryReader { reader in
                ZStack {
                    ForEach(
                        Array(models.enumerated()),
                        id: \.element
                    ) { index, item in
                        if (models.count - 3)...models.count ~=
                            index {
                            
                            Card(
                                model: item, reader: reader
                            ) { model, isLiked in
                                withAnimation(.spring()) {
                                    onRemove(model, isLiked)
                                }
                            }
                            .frame(
                              width: 330,
                              height: Constants.cardHeight
                            )
    //                        .offset(x: 0, y: cardOffset(in: reader, index: index))
                        }
                    }

                }
    //            .frame(width: reader.size.width)
    //            .offset(y: -25)
            }
            .frame(height: Constants.cardHeight + 50.0)
            .transition(.scale)
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
        }
        
    }
    
    private func cardWidth(in geometry: GeometryProxy, index: Int) -> CGFloat? {
      let offset = cardOffset(in: geometry, index: index)

      let addedValue: CGFloat
      if geometry.size.width > 1536 {
        addedValue = 700
      } else if geometry.size.width > 1024 {
        addedValue = 400
      } else if geometry.size.width > 512 {
        addedValue = 100
      } else {
        addedValue = 0
      }

      let result = geometry.size.width - offset - addedValue

      if result <= 0 {
        return nil
      } else {
        return result
      }
    }

    private func cardOffset(in geometry: GeometryProxy, index: Int) -> CGFloat {
      CGFloat(models.count - 1 - index) * 12
    }
}

private enum Constants {
  static let cardHeight: CGFloat = 380
}
    

struct SwipePage_Previews: PreviewProvider {
    static var previews: some View {
        SwipePage()
    }
}
