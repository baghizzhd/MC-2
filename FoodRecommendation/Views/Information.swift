//
//  RecommendationService.swift
//  ProjectRecommenderTrial
//
//  Created by Baghiz on 05/06/24.
//



import SwiftUI

struct Information: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Instruction")
                .fontWeight(.bold)
                .font(.system(size:24))
                .foregroundColor(.white)
            
            
            Text("Swipe right to like")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.top)
            Text("Swipe left to dislike")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.bottom)
                
            
            Text("The Recommendations are based on your liked.")
                .font(.system(size: 12))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            Button(action: { dismiss() }) {
                Text("Got it!")
            }
            .font(.headline)
            .tint(Color.white)
            .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.6))
            .buttonStyle(.borderedProminent)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.blue)
    }
}

struct Information_Previews: PreviewProvider {
    static var previews: some View {
        Information()
    }
}
