//
//  RecommendationService.swift
//  ProjectRecommenderTrial
//
//  Created by Baghiz on 05/06/24.
//

import Foundation
import TabularData

#if canImport(CreateML)
import CreateML
#endif

final class RecommendationStore {
  private let queue = DispatchQueue(label: "com.recommendation-service.queue", qos: .userInitiated)

  func computeRecommendations(basedOn items: [FavouriteWrapper<Food>]) async throws -> [Food] {
    return try await withCheckedThrowingContinuation { continuation in
      queue.async {
        #if targetEnvironment(simulator)
        continuation.resume(throwing: NSError(domain: "Simulator Not Supported", code: -1))
        #else
        let trainingData = items.filter {
          $0.isFavorite != nil
        }

        let trainingDataFrame = self.dataFrame(for: trainingData)

        let testData = items
        let testDataFrame = self.dataFrame(for: testData)

        do {
          let regressor = try MLLinearRegressor(trainingData: trainingDataFrame, targetColumn: "favorite")

          let predictionsColumn = (try regressor.predictions(from: testDataFrame)).compactMap { value in
            value as? Double
          }

          let sorted = zip(testData, predictionsColumn)
            .sorted { lhs, rhs -> Bool in
              lhs.1 > rhs.1
            }
            .filter {
              $0.1 > 0
            }
            .prefix(10)

          print(sorted.map(\.1))

          let result = sorted.map(\.0.model)

          continuation.resume(returning: result)
        } catch {
          continuation.resume(throwing: error)
        }
        #endif
      }
    }
  }

  private func dataFrame(for data: [FavouriteWrapper<Food>]) -> DataFrame {
    var dataFrame = DataFrame()

    dataFrame.append(
      column: Column(name: "soup", contents: data.map(\.model.soup.rawValue))
    )

    dataFrame.append(
      column: Column(name: "origin", contents: data.map(\.model.origin.rawValue))
    )

    dataFrame.append(
      column: Column(name: "taste_profile", contents: data.map(\.model.taste_profile.rawValue))
    )

    dataFrame.append(
      column: Column(name: "main_ingredients", contents: data.map(\.model.main_ingredients.rawValue))
    )
    
    dataFrame.append(
      column: Column(name: "carbohydrate_source", contents: data.map(\.model.carbohydrate_source.rawValue))
    )
      
    dataFrame.append(
      column: Column(name: "spice_level", contents: data.map(\.model.spice_level.rawValue))
    )
      
      
    dataFrame.append(
      column: Column<Int>(
        name: "favorite",
        contents: data.map {
          if let isFavorite = $0.isFavorite {
            return isFavorite ? 1 : -1
          } else {
            return 0
          }
        }
      )
    )

    return dataFrame
  }
}
