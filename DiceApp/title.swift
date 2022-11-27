//
//  title.swift
//  DiceApp
//
//  Created by Carter Hawkins on 11/26/22.
//

import SwiftUI

struct title: View {
    
    @State private var rotation: Double = 0
    @State private var scale: Double = 1
    var body: some View {
        HStack {
            Text("Dice Roll")
                .font(.title)
                .fontWeight(.bold)
                .offset(y: 2)
            Text("🎲")
                .font(.title)
                .fontWeight(.bold)
                .offset(y: 2)
                .rotationEffect(.degrees(rotation))
        }
        .scaleEffect(scale)
        .onTapGesture {
            withAnimation {
                for _ in 1...360 {
                    rotation += 1
                }
                scale = 1.15
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        scale = 1.0
                    }
                }
            }
        }
    }
}

struct title_Previews: PreviewProvider {
    static var previews: some View {
        title()
    }
}
