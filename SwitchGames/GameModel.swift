//
//  GameModel.swift
//  SwitchGames
//
//  Created by Tom Shen on 2021/6/11.
//

import Foundation
import SwiftUI
import Combine

let rows = 9
let columns = 10
let numGaps = 3
let distanceBetweenPoles = 3

class GameModel: ObservableObject {
    
    @Published var gameOver = false
    @Published var currentScore = 0
    // MARK: Timers
    var updateTimer: AnyPublisher<Void, Never> {
        Timer.publish(every: 0.35, on: .main, in: .default)
            .autoconnect()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    var updateTimerV2: AnyPublisher<Void, Never> {
        Timer.publish(every: 0.20, on: .main, in: .default)
            .autoconnect()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    var updateBirdTimer: AnyPublisher<Void, Never> {
        Timer.publish(every: 0.01, on: .main, in: .default)
            .autoconnect()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    var birdPosition = rows / 2
    
    var allPoles = Array(repeating: Pole(isempty: true, topPoleHeight: 0), count: columns)
    
    @Published var matrix: [MatrixRow] = {
        var result = [MatrixRow]()
        for i in 0..<rows {
            var matrixRow = MatrixRow()
            for j in 0..<columns {
                matrixRow.columns.append(false)
            }
            result.append(matrixRow)
        }
        return result
    }()
    
    func setup() {
        if currentScore <= 10 {
            updateTimer
                .sink(receiveValue: createPole)
                .store(in: &subscriptions)
        } else {
            updateTimerV2
                .sink(receiveValue: createPole)
                .store(in: &subscriptions)
        }
        
        updateBirdTimer
            .sink(receiveValue: updateBird)
            .store(in: &subscriptions)
        
        $gameOver
            .dropFirst()
            .sink { _ in
                self.subscriptions.forEach {
                    $0.cancel()
                }
            }
            .store(in: &subscriptions)
        
        $currentScore
            .filter({ $0 == 10 })
            .sink { _ in
                self.subscriptions.forEach {
                    $0.cancel()
                }
                self.setup()
            }
            .store(in: &subscriptions)
    }
    
    func printMatrix() {
        matrix.forEach { row in
            print(row)
        }
    }
    var poleGenerateCounter = 0
    
    func createPole(){
        let newIsEmpty = poleGenerateCounter == 0 ? false : true
        incrementCounter()
        let topPoleHeight = Int.random(in: 0..<(columns - (numGaps + 1)))
        let newPole = Pole(isempty: newIsEmpty, topPoleHeight: topPoleHeight)
        allPoles.append(newPole)
        allPoles.removeFirst()
        updatePole()
    }
    
    func incrementCounter() {
        poleGenerateCounter += 1
        if poleGenerateCounter > distanceBetweenPoles {
            poleGenerateCounter = 0
        }
    }
    
    func updatePole() {
        for i in 0..<rows {
            for j in 0..<columns {
                let pole = allPoles[j]
                if !pole.isempty {
                    let bottomPoleStartPosition = pole.topPoleHeight + numGaps
                    if i <= pole.topPoleHeight || i > bottomPoleStartPosition {
                        matrix[i][j] = true
                        collisionTest(i, j)
                        scoreCount(i, j, isempty: pole.isempty)
                    } else {
                        matrix[i][j] = false
                    }
                } else {
                    matrix[i][j] = false
                }
            }
        }
    }
    
    var dropCounter = 0
    
    func updateBird(){
        if dropCounter < 30{
            matrix[birdPosition][1] = true
            dropCounter += 1
        }
        
        else{
            if birdPosition >= rows - 1{
                gameOver = true
            }
            else{
                matrix[birdPosition][1] = false
                birdPosition += 1
                matrix[birdPosition][1] = true
                dropCounter = 0
            }
        }
    }
    
    func increaseBirdHeight(){
        if birdPosition <= 0{
            gameOver = true
        }
        else{
            matrix[birdPosition][1]=false
            birdPosition -= 1
            matrix[birdPosition][1] = true
        }
    }
    
    func collisionTest(_ row: Int, _ column: Int){
        if column == 1 && row == birdPosition {
            gameOver = true
        }
    }
    
    func scoreCount(_ row: Int, _ column: Int, isempty: Bool){
        if row == 0 && column == 1 && isempty == false && gameOver == false{
//            print("Increment score: \(row) \(column)")
            currentScore += 1
//            print(currentScore)
        }
    }
    
    func restart() {
        currentScore = 0
        dropCounter = 0
        allPoles = Array(repeating: Pole(isempty: true, topPoleHeight: 0), count: columns)
        birdPosition = rows / 2
        gameOver = false
        updatePole()
        setup()
    }
}

struct Pole{
    var isempty: Bool
    var topPoleHeight: Int
}
struct MatrixRow: Identifiable, CustomStringConvertible, Equatable {
    let id = UUID()
    var columns: [SwitchState] = []
    
    subscript(index: Int) -> Bool {
        get {
            columns[index].state
        }
        set {
            columns[index].state = newValue
        }
    }
    
    /// Equatable for this class matches value rather than `id`
    static func == (lhs: MatrixRow, rhs: MatrixRow) -> Bool {
        return lhs.columns == rhs.columns
    }
    
    var description: String {
        return "\(columns)"
    }
}

struct SwitchState: Identifiable, Equatable, ExpressibleByBooleanLiteral, CustomStringConvertible {
    let id = UUID()
    var state: Bool
    init(booleanLiteral value: Bool) {
        self.state = value
    }
    
    var description: String {
        return state ? "1" : "0"
    }
    
    static func == (lhs: SwitchState, rhs: SwitchState) -> Bool {
        return lhs.state == rhs.state
    }
}
