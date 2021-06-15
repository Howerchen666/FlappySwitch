//
//  GameOverView.swift
//  SwitchGames
//
//  Created by Hower Chen on 2021/6/15.
//

import SwiftUI

struct GameOverView: View {
    var finalScore = 0
    
    var body: some View {
        VStack{
        Text("Game Over!!!😆😆😆")
            .font(.largeTitle)
            .foregroundColor(Color.red)
        Text("Your Score is:" + String(finalScore))
        }
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
        .background(Color.white)
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
