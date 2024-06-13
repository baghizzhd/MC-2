import UIKit.UIImage
import Foundation

struct Food: Codable {
  let id = UUID()
  let name: String
  let imageName: String
  let soup: Soup
  let origin: Origin
  let taste_profile: Taste
  let main_ingredients: MainIng
  let carbohydrate_source: Carbo
  let spice_level: Spice

  enum CodingKeys: String, CodingKey {
    case name
    case imageName = "image_name"
    case soup, origin, taste_profile, main_ingredients, carbohydrate_source, spice_level
  }

    enum Soup: String, Codable {
      case soupy
      case nosoupy
    }
    
  enum Origin: String, Codable {
    case indonesian
    case chinese
    case japanese
    case asian
    case italian
    case western
  }
    
    enum Taste: String, Codable {
      case sweet
      case salty
      case other
    }

  enum Carbo: String, Codable {
    case rice
    case noodle
    case bread
    case potato
  }

  enum Spice: String, Codable {
    case spicy
    case mild
  }

  enum MainIng: String, Codable {
    case beef
    case chicken
    case pork
    case fish
    case seafood
    case othermain
  }
}

extension Food: Identifiable, Hashable, TextImageProvider {
}

extension Food {
  var image: UIImage? {
    UIImage(named: imageName)
  }
}

extension Food {
  static var origin: Food {
    Food(
      name: "Soto Ayam",
      imageName: "soto",
      soup: .soupy,
      origin: .indonesian,
      taste_profile: .salty,
      main_ingredients: .chicken,
      carbohydrate_source: .rice,
      spice_level: .mild
    )
  }
}
