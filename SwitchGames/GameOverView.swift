//
//  GameOverView.swift
//  SwitchGames
//
//  Created by Hower Chen on 2021/6/15.
//

import SwiftUI
import Combine

struct GameOverView: View {
    var finalScore = 0
    @ObservedObject var gameModel: GameModel
    @AppStorage("highScore") var highScore: Int = 0
    
    var body: some View {
        VStack{
            Text("Game Over!!!😆😆😆")
                .font(.largeTitle)
                .foregroundColor(Color.red)
            Text("Your Score is:" + String(finalScore))
            Text("Your Highest Score is:" + String(highScore))
            Button(action: gameModel.restart) {
                Text("Restart Game")
            }
        }
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            if finalScore > highScore {
                highScore = finalScore
            }
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(gameModel: .init())
    }
}
