//
//  ContentView.swift
//  SwitchGames
//
//  Created by Tom Shen on 2021/6/11.
//

import SwiftUI
import Combine

// Size 9 X 10

struct ContentView: View {
    @StateObject var gameModel = GameModel()
    
    var createtimer: AnyPublisher<Void, Never> {
        Timer.publish(every: 3, on: .main, in: .default)
            .autoconnect()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    var updatetimer: AnyPublisher<Void, Never> {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        ZStack {
            VStack {
                ForEach($gameModel.matrix) { $rows in
                    HStack {
                        ForEach($rows.columns) { $cell in
                            Toggle("1", isOn: $cell.state)
                        }
                    }
                }
            }
            .labelsHidden()
            .onReceive(createtimer) { _ in
                gameModel.createPole()
//                gameModel.updatePole()
            }
            .onReceive(updatetimer) { _ in
                gameModel.updatePole()
            }
            
            OverlayControlView(onTap: tapGesture)
        }
    }
    
    func tapGesture() {
        print("Access")
        gameModel.createPole()
    }
}

struct OverlayControlView: View {
    var onTap: () -> ()
    
    var body: some View {
        Color.white
            .opacity(0.5)
            .onTapGesture(perform: onTap)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
