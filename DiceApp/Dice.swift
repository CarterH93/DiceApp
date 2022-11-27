//
//  Dice.swift
//  DiceApp
//
//  Created by Carter Hawkins on 11/26/22.
//

import SwiftUI
import CoreHaptics

struct Dice: View {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    @EnvironmentObject var numberStorage: numberStorage
    
    @State private var topNum = 18
    @State private var leftNum = 12
    @State private var rightNum = 25
    
    @State private var diceRollAnimationActive = false
    @State private var counter = 0
    
    
    @State private var engine: CHHapticEngine?
    
    var randomNumber: [Int] {
        var numbersArray = [Int]()
        var tempNum = 0
        
        for _ in 1...3 {
            repeat {
                tempNum = Int.random(in: 1...numberStorage.DieSides)
            } while tempNum == 0 || numbersArray.contains(tempNum)
            numbersArray.append(tempNum)
        }
        return numbersArray
    }
    
    var body: some View {
            ZStack {
                
                Image("dice")
                    .resizable()
                    
                    
                Text(String(topNum))
                    .position(x: 45, y: 45)
                    .font(.system(size: 70))
                    .rotationEffect(.degrees(45))
                    .rotation3DEffect(.degrees(45), axis:(x: 1, y: 0, z: 0))
                    .foregroundColor(.black)
                
                Text(String(rightNum))
                    .position(x: 152, y: 128)
                    .font(.system(size: 70))
                    .rotationEffect(.degrees(-14))
                    .rotation3DEffect(.degrees(45), axis:(x: 0, y: 1, z: 0))
                    .foregroundColor(.black)
                
                Text(String(leftNum))
                    .position(x: 40, y: 132)
                    .font(.system(size: 70))
                    .rotationEffect(.degrees(13))
                    .rotation3DEffect(.degrees(49), axis:(x: 0, y: -1, z: 0))
                    .foregroundColor(.green)
                    
            }
            .onAppear(perform: prepareHaptics)
            .accessibilityElement(children: .combine)
            .onReceive(timer) { time in
                if diceRollAnimationActive == true {
                    let numbers = randomNumber
                    topNum = numbers[0]
                    leftNum = numbers[1]
                    rightNum = numbers[2]
                    counter += 1
                    
                    if counter >= 15 {
                        counter = 0
                        diceRollAnimationActive = false
                        timer.upstream.connect().cancel()
                        numberStorage.finalDiceRole = String(leftNum)
                        numberStorage.addNumber(leftNum)
                    }
                    
                }
                
            }
            .onTapGesture {
                diceRollAnimationActive = true
                complexSuccess()
                
                    
                
            }
        .frame(width: 200, height: 200)
        
    }
    
    
    
    
    
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        
        for i in stride(from: 0, to: 0.6, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    
}

struct Dice_Previews: PreviewProvider {
    static var previews: some View {
        Dice()
            .environmentObject(numberStorage())
    }
}
