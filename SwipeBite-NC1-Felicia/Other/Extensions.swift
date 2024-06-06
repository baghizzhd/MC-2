//
//  Extensions.swift
//  NC1-felicia
//
//  Created by Felicia Graciella on 09/05/23.
//

import SwiftUI

extension Double {
    static func remap(from: Double, fromMin: Double, fromMax: Double, toMin: Double, toMax: Double) -> Double {
        let fromAbs: Double = from - fromMin
        let fromMaxAbs: Double = fromMax - fromMin
        let normal: Double = fromAbs / fromMaxAbs
        let toMaxAbs = toMax - toMin
        let toAbs: Double = toMaxAbs * normal
        var to: Double = toAbs + toMin
        
        to = abs(to)
        
        if to < toMin {return toMin}
        if to > toMax {return toMax}
        
        return to
    }
}

extension Color {
    public static let bg = Color("bg")
    public static let sbred = Color("sbred")
    public static let sbgreen = Color("sbgreen")
    public static let sbyellow = Color("sbyellow")
    public static let sborange = Color("sborange")
}

struct CardViewConsts {
    static let cardRotLimit: CGFloat = 20.0
    static let dislikeTriggerZone: CGFloat = -0.1
    static let likeTriggerZone: CGFloat = 0.1
    
    static let cardRatio: CGFloat = 1.333
    static let cardCornerRadius: CGFloat = 24.0
    static let cardShadowOffset: CGFloat = 16.0
    static let cardShadowBlur : CGFloat = 16.0
    
    static let labelTextSize: CGFloat = 24.0
    static let labelTextKerning: CGFloat = 6.0
    
    static let motionRemapFromMin: Double = 0.0
    static let motionRemapFromMax: Double = 0.25
    static let motionRemapToMin: Double = 0.0
    static let motionRemapToMax: Double = 1.0
    
    static let springResponse: Double = 0.5
    static let springBlendDur: Double = 0.3
    
    static let iconSize: CGSize = CGSize(width: 96.0, height: 96.0)
    
}

enum dayState {
    case like
    case dislike
    case empty
}
