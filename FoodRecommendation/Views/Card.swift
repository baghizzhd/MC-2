//
//  RecommendationService.swift
//  ProjectRecommenderTrial
//
//  Created by Baghiz on 05/06/24.
//

import SwiftUI

struct Card<Model>: View where Model: TextImageProvider {
    private let model: Model
    private let onRemove: (_ model: Model, _ isLiked: Bool) -> Void
    var reader : GeometryProxy
    
    init(
      model: Model,
      reader: GeometryProxy,
      onRemove: @escaping (_ model: Model, _ isLiked: Bool) -> Void = { _, _ in }
    ) {
      self.model = model
      self.reader = reader
      self.onRemove = onRemove
    }
    
    @State var offsets : Double = 0
    
    @State var translation : CGSize = .zero
    @State var motionOffset : Double = 0.0
    @State var motionScale : Double = 0.0
    @State var lastCardState : dayState = .empty
    
    func getIconName(state: dayState) -> String {
        switch state {
        case .like: return "like"
        case .dislike: return "dislike"
        default: return "empty"
        }
    }
    
    func setCardState(offset: CGFloat) -> dayState{
        if offset <= CardViewConsts.dislikeTriggerZone { return .dislike
        }
        if offset >= CardViewConsts.likeTriggerZone { return .like }

        return .empty
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack{
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
                        width: proxy.size.width,
                      height: 380,
                      alignment: .center
                    )
                    .cornerRadius(10)
                    
                    .clipped()
                    .overlay {
                      Color(
                        lastCardState == .like ? .green.withAlphaComponent(0.3) :
                            (lastCardState == .dislike ? .orange.withAlphaComponent(0.3) : .clear)
                      )
                    }
                    .overlay(
                      alignment: lastCardState == .like ? .topLeading : (lastCardState == .dislike ? .topTrailing : .top)
                    ) {
                      Image(getIconName(state: self.lastCardState)
                      )
                      .resizable()
                      .imageScale(.large)
                      .frame(width: 32, height: 32)
                      .foregroundColor(Color(uiColor: .systemBackground))
                      .padding(8)
                      .background(
                        Circle()
                          .background(.thinMaterial)
                      )
                      .clipShape(Circle())
                      .padding(8)
                      .opacity(lastCardState == .empty ? 0.0 : 1.0)
                    }
                
                VStack {
                    Spacer()
                    HStack {
                        Text(model.name)
                            .shadow(radius: 5)
                            .padding(.bottom, 16)
                            .padding(.leading, 25)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 24))
        
                        Spacer()
                    }
                    
                }
                
                    
            }
            .frame(width: 350, height: 380, alignment: .center)
            
            .offset(x:offsets)
            .padding([.top, .bottom, .trailing])
            .rotationEffect(.degrees(Double(self.translation.width / reader.size.width * CardViewConsts.cardRotLimit)), anchor: .bottom)
            .offset(x: self.translation.width, y: self.translation.height)
            .animation(.interactiveSpring(response: CardViewConsts.springResponse, blendDuration: CardViewConsts.springBlendDur))
            .gesture(DragGesture()
                .onChanged{
                    gesture in withAnimation(.spring()) {
                        self.motionOffset = Double(gesture.translation.width / reader.size.width)
                        self.motionScale = Double.remap(from: self.motionOffset, fromMin: CardViewConsts.motionRemapFromMin, fromMax: CardViewConsts.motionRemapFromMax, toMin: CardViewConsts.motionRemapToMin, toMax: CardViewConsts.motionRemapToMax)
                        self.lastCardState = setCardState(offset: gesture.translation.width)
                        
                        self.translation = gesture.translation
                    }
                }
                .onEnded({(value) in
                    withAnimation(.spring()) {
                        if value.translation.width > 100 {
                            offsets = 1000
                            onRemove(model, lastCardState == .like)
                        }
                        else if value.translation.width < -100 {
                            offsets = -1000
                            lastCardState = .dislike
                            onRemove(model, lastCardState == .like)
                        }
                        else{
                            offsets = 0
                            self.translation = .zero
                            lastCardState = .empty
                            self.motionScale = 0.0
                        }
                    }
                })
            )
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            Card(model: Food.origin, reader: proxy)
        }
    }
}
