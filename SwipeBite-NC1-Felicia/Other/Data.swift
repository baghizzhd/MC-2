//
//  Data.swift
//  NC1-SwipeBite-Felicia
//
//  Created by Felicia Graciella on 10/05/23.
//

import SwiftUI

var days : [String] = ["Wednesday", "Tuesday", "Monday"]


struct Tools : Identifiable {
    var id : Int
    var image : String
    var name : String
    var offset : CGFloat
    var opacity : Double
    var place : Int
}

var design_tools = [
    Tools(id: 0, image: "logo", name: "Sketch", offset: 0, opacity: 1, place: 1),
    Tools(id: 1, image: "logo", name: "Figma", offset: 0, opacity: 1, place: 2),
    Tools(id: 2, image: "logo", name: "XD", offset: 0, opacity: 1, place: 3),
    Tools(id: 3, image: "logo", name: "Ilustrator", offset: 0, opacity: 1, place: 4),
    Tools(id: 4, image: "logo", name: "Photoshop", offset: 0, opacity: 1, place: 5),
    Tools(id: 5, image: "logo", name: "Invision", offset: 0, opacity: 1, place: 6),
    Tools(id: 6, image: "logo", name: "Affinity Photos", offset: 0, opacity: 1, place: 7),
]
