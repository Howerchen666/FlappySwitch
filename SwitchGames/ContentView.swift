//
//  ContentView.swift
//  SwitchGames
//
//  Created by Tom Shen on 2021/6/11.
//

import SwiftUI

// Size 9 X 9

struct ContentView: View {
    var body: some View {
        HStack {
            Toggle("1", isOn: .constant(true))
            Toggle("1", isOn: .constant(true))
            Toggle("1", isOn: .constant(true))
            Toggle("1", isOn: .constant(true))
            Toggle("1", isOn: .constant(true))
            Toggle("1", isOn: .constant(true))
            Toggle("1", isOn: .constant(true))
            Toggle("1", isOn: .constant(true))
            Toggle("1", isOn: .constant(true))
        }
        .labelsHidden()
        .overlay(OverlayControlView())
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
