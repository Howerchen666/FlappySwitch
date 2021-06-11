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
        let bottomPoleStartPosition = topPoleHeight + numGaps
        for i in matrix.indices{
            if i <= topPoleHeight || i > bottomPoleStartPosition {
                matrix[i][columns - 1] = true
            }
            else{
                matrix[i][columns - 1] = false
            }
        }
    }
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
