//
//  ContentView.swift
//  SwitchGames
//
//  Created by Tom Shen on 2021/6/11.
//

import SwiftUI

// Size 10 X 9

struct ContentView: View {
    @StateObject var gameModel = GameModel()
    
    var body: some View {
        VStack {
            ForEach($gameModel.matrix) { $allRows in
                HStack {
                    ForEach($allRows.row) { $row in
                        Toggle("1", isOn: $row.state)
                    }
                }
            }
        }
        .labelsHidden()
        .overlay(OverlayControlView())
        .onAppear {
            access()
        }
    }
    
    func access() {
        gameModel.matrix[1][0] = true
    }
}

struct OverlayControlView: View {
    var body: some View {
        Color.white
            .opacity(0.5)
            .onTapGesture {
                print("Tapped")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
