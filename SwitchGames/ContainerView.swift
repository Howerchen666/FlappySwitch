//
//  ContainerView.swift
//  SwitchGames
//
//  Created by Hower Chen on 2021/6/15.
//

import SwiftUI

struct ContainerView: View {
    @State var displayState = 0
    var body: some View {
        if displayState == 0{
            Button(action: {displayState = 1}) {
                Text("Start Game!")
            }
        }
        
        if displayState == 1{
            ContentView()
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
