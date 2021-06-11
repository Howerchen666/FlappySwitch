//
//  GameModel.swift
//  SwitchGames
//
//  Created by Tom Shen on 2021/6/11.
//

import Foundation
import SwiftUI

let rows = 9
let columns = 10
let numGaps = 3

class GameModel: ObservableObject {
    
    var allPoles = [Pole]()
    
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
    
    func printMatrix() {
        matrix.forEach { row in
            print(row)
        }
    }
    
    func createPole(){
        let topPoleHeight = Int.random(in: 0..<(columns - (numGaps + 1)))
        allPoles.append(Pole(x: columns - 1, topPoleHeight: topPoleHeight))
    }
    
    func updatePole(){
        var removePadding = 0
        for poleIndex in allPoles.indices{
            let accessIndex = poleIndex - removePadding
            let pole = allPoles[accessIndex]
            let topPoleHeight = pole.topPoleHeight
            let columnIndex = pole.x
            let bottomPoleStartPosition = topPoleHeight + numGaps
            for i in matrix.indices{
                if i <= topPoleHeight || i > bottomPoleStartPosition {
                    matrix[i][columnIndex] = true
                }
                else{
                    matrix[i][columnIndex] = false
                }
            }
            allPoles[accessIndex].x -= 1
            if allPoles[accessIndex].x < 0{
                allPoles.remove(at: accessIndex)
                removePadding += 1
            }
        }
    }
}

struct Pole{
    var x: Int
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
