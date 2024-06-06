//
//  SwipePage.swift
//  NC1-felicia
//
//  Created by Felicia Graciella on 09/05/23.
//

import SwiftUI

struct SwipePage: View {
    let toolNames = design_tools.map { $0.name }
    
    var body: some View {
        VStack{
            Swipe(daysToCheck: toolNames)
            Recommendations()
                .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Recommendations : View {
    var body: some View {
        VStack {
            HStack {
                Text("Recommendations")
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack{
                    Rectangle()
                        .frame(width: 200, height: 250)
                    Rectangle()
                        .frame(width: 200, height: 250)
                    Rectangle()
                        .frame(width: 200, height: 250)
                    Rectangle()
                        .frame(width: 200, height: 250)
                }
                
            }
        }
    }
}

struct Swipe: View {
    private let cardOffset : CGFloat = 24
    private let cardRatio : CGFloat = 1.333
    private let cardOffsetMultiplier : CGFloat = 4
    private let cardAlphaStep : Double = 0.1
    
    private var yCardsOffset: CGFloat {
        return -CGFloat(daysToCheck.count) * cardOffset / 2
    }
    
    private func calculateCardWidth(geo: GeometryProxy, offset: CGFloat, cardIndex: Int) -> CGFloat {
        return geo.size.width - ((offset * 2) * CGFloat(cardIndex))
    }
    
    private func calculateCardYOffset(offset: CGFloat, cardIndex: Int)->CGFloat{
        return offset * CGFloat(cardIndex)
    }
    
    private func calculateItemInvertIndex(arr:[String], item:String)->Int{
        if arr.isEmpty{return 0}
        return arr.count - 1 - arr.firstIndex(of: item)!
    }
    
    private func calculateCardAlpha(cardIndex: Int)->Double{
        return 1.0 - Double(cardIndex) * cardAlphaStep
    }
    
    
    @State var swiped = 0
    
    var daysToCheck : [String]
    
    var body: some View {
        GeometryReader{reader in
            ZStack {
                ForEach(design_tools.reversed()){ tool in
                    CardView(tool:tool, reader: reader, swiped : $swiped)
                }
            }
            .offset(y: -25)
        }
    }
    
//    func getRotation(offset: CGFloat)-> Double{
//        let value = offset / 150
//
//        let angle : CGFloat = 10
//        let degree = Double(value * angle)
//
//        return degree
//    }
}

struct CardView : View {
    var cardAlpha : Double = 1.0
    
    var tool : Tools
    var reader : GeometryProxy
    @Binding var swiped : Int
    
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
    
//    func restoreCard(id: Int) {
//        var currentCard = design_tools[id]
//
//        currentCard.id = design_tools.count
//        design_tools.append(currentCard)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            withAnimation {
//                design_tools[design_tools.count - 1].offset = 0
//            }
//        }
//    }
    
//    func getRotation(offset: CGFloat)-> Double{
//        let value = offset / 150
//
//        let angle : CGFloat = 10
//        let degree = Double(value * angle)
//
//        return degree
//    }
    
    @State var translation : CGSize = .zero
    @State var motionOffset : Double = 0.0
    @State var motionScale : Double = 0.0
    @State var lastCardState : dayState = .empty
    
    let value = design_tools.map { $0.offset }
    
    var body: some View{
        GeometryReader {
            geometry in
            
            VStack {
                Spacer(minLength: 0)
                
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
                    
                    HStack{
//                        Spacer()
                        
                        VStack {
                            Image(getIconName(state: self.lastCardState))
                                .frame(width: CardViewConsts.iconSize.height)
                                .opacity(self.motionScale)
                                .scaleEffect(CGFloat(self.motionScale))
                            Spacer()
                        }
                    }
                    
                    
                    VStack{
                        Image("\(tool.image)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top)
                            .padding(.horizontal, 25)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("\(tool.name)")
                                    .font(.system(size: 40))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                .padding(.top)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                        .padding(.top, 25)
                    }
                })
                .frame(height: reader.frame(in: .global).height - 120)
                .padding(.vertical)
                .background(Color.bg)
                .cornerRadius(25)
                .padding(.horizontal, 30 + (CGFloat(tool.id - swiped) * 10))
                .offset(y: tool.id - swiped <= 2 ?CGFloat(tool.id - swiped)*25:50)
                .shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 5)
                
                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
            .offset(x:design_tools[tool.id].offset)
            .opacity(design_tools[tool.id].opacity)
            .rotationEffect(.degrees(Double(self.translation.width / reader.size.width * CardViewConsts.cardRotLimit)), anchor: .bottom)
            .offset(x: self.translation.width, y: self.translation.height)
            
            .animation(.interactiveSpring(response: CardViewConsts.springResponse, blendDuration: CardViewConsts.springBlendDur))
            .gesture(DragGesture()
                .onChanged{
                    gesture in
                    
                    self.translation = gesture.translation
                    self.motionOffset = Double(gesture.translation.width / reader.size.width)
                    self.motionScale = Double.remap(from: self.motionOffset, fromMin: CardViewConsts.motionRemapFromMin, fromMax: CardViewConsts.motionRemapFromMax, toMin: CardViewConsts.motionRemapToMin, toMax: CardViewConsts.motionRemapToMax)
                    self.lastCardState = setCardState(offset: gesture.translation.width)
                    
                    if gesture.translation.width > 30 {
                        design_tools[tool.id].offset = gesture.translation.width
                    }
                }
                .onEnded({(value) in
                    withAnimation(.spring()) {
                        if value.translation.width > 100 {
                            design_tools[tool.id].offset = 1000
                            design_tools[tool.id].opacity = 0.2
                            print(design_tools[tool.id].opacity)
                            swiped = tool.id + 1
//                            restoreCard(id: tool.id)
                        }
                        else if value.translation.width < -100 {
                            design_tools[tool.id].offset = -1000
                            design_tools[tool.id].opacity = 0.2
                            swiped = tool.id + 1
//                            restoreCard(id: tool.id)
                        }
                        else{
                            design_tools[tool.id].offset = 0
                            self.translation = .zero
                            self.motionScale = 0.0
                        }
                    }
                })
            )
        }
        
    }
}

struct SwipePage_Previews: PreviewProvider {
    static var previews: some View {
        SwipePage()
    }
}
