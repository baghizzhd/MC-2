//
//  RecommendationService.swift
//  ProjectRecommenderTrial
//
//  Created by Baghiz on 05/06/24.
//

import Foundation

@MainActor
final class MainModel: ObservableObject {
  private var allFoods: [FavouriteWrapper<Food>] = []
  @Published private(set) var foods: [Food] = []
  @Published private(set) var recommendations: [Food] = []

  private let recommendationStore: RecommendationStore
  private var recommendationsTask: Task<Void, Never>?

  init(recommendationStore: RecommendationStore = RecommendationStore()) {
    self.recommendationStore = recommendationStore
  }

  func loadAllFoods() async {
    guard let url = Bundle.main.url(forResource: "food", withExtension: "json") else {
      return
    }

    do {
      let data = try Data(contentsOf: url)
      allFoods = (try JSONDecoder().decode([Food].self, from: data)).shuffled().map {
        FavouriteWrapper(model: $0)
      }
      foods = allFoods.map(\.model)
    } catch {
      print(error.localizedDescription)
    }
  }

  func didRemove(_ item: Food, isLiked: Bool) {
    foods.removeAll { $0.id == item.id }
    if let index = allFoods.firstIndex(where: { $0.model.id == item.id }) {
      allFoods[index] = FavouriteWrapper(model: item, isFavorite: isLiked)
    }

    recommendationsTask?.cancel()
    recommendationsTask = Task {
      do {
        let result = try await recommendationStore.computeRecommendations(basedOn: allFoods)
        if !Task.isCancelled {
          recommendations = result
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  func resetUserChoices() {
    foods = allFoods.map(\.model)
    recommendations = []
  }
}
