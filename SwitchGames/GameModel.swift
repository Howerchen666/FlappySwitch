//
//  GameModel.swift
//  SwitchGames
//
//  Created by Tom Shen on 2021/6/11.
//

import Foundation
import SwiftUI

class GameModel: ObservableObject {
    @Published var matrix: [MatrixRow] = Array(repeating: MatrixRow(count: 10), count: 9)
}

struct MatrixRow: Identifiable {
    let id = UUID()
    var row: [SwitchState]
    
    init(count: Int) {
        row = Array(repeating: false, count: count)
    }
    
    subscript(index: Int) -> Bool {
        get {
            row[index].state
        }
        set {
            row[index].state = newValue
        }
    }
}

struct SwitchState: Identifiable, ExpressibleByBooleanLiteral {
    let id = UUID()
    var state: Bool
    init(booleanLiteral value: Bool) {
        self.state = value
    }
}
