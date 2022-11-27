//
//  ContentView.swift
//  DiceApp
//
//  Created by Carter Hawkins on 11/26/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var numberStorage: numberStorage
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image("background")
                        .resizable()
                        .ignoresSafeArea()
                        .accessibilityHidden(true)
                    
                    
                    VStack {
                        Dice()
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel("Dice")
                            .accessibilityHint("Select to roll dice")
                            .accessibilityValue("Rolled \(numberStorage.finalDiceRole)")
                        Text("Tap to Roll Dice")
                            .foregroundColor(.white)
                            .padding(8)
                            .accessibilityHidden(true)
                        Text("Dice Roll Number:  \(numberStorage.finalDiceRole)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .accessibilityHidden(true)
                    }
                }
                VStack {
                    title()
                        .accessibilityHidden(true)
                    List {
                        ForEach(numberStorage.RolledNumbers) { number in
                            Text("Rolled \(number.number)")
                        }
                    }
                }
                .toolbar() {
                    ToolbarItem(placement: .bottomBar) {
                        Picker("\(numberStorage.DieSides) Sided Die", selection: $numberStorage.DieSides) {
                            ForEach(3...100, id: \.self) {
                                Text("\($0) Sided Die")
                            }
                        }
                        .pickerStyle(.menu)
                        
                    } 
                    ToolbarItem(placement: .bottomBar) {
                        Button("Clear", role: .destructive) {
                            numberStorage.RolledNumbers.removeAll()
                        }
                        .foregroundColor(.red)
                        
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(numberStorage())
    }
}
