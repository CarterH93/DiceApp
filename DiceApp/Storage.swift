//
//  Storage.swift
//  DiceApp
//
//  Created by Carter Hawkins on 11/26/22.
//

import Foundation
import SwiftUI

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}


let savePath = getDocumentsDirectory().appendingPathComponent("SavedNumbers")


class numberStorage: ObservableObject {
    @Published var RolledNumbers = [PastNumber]() {
        
        //did set for saving data to the disk
        
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(RolledNumbers) {
                
                let str = encoded
                let url = savePath
                
                do {
                    try str.write(to: url, options: .atomicWrite)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    @Published var DieSides = 6
    
    @Published var finalDiceRole = ""
    
    
    func addNumber(_ num: Int) {
        RolledNumbers.insert(PastNumber(number: num), at: 0)
    }
    
    
    init() {
            if let savedItems = try? Data(contentsOf: savePath) {
                if let decodedItems = try? JSONDecoder().decode([PastNumber].self, from: savedItems) {
                    RolledNumbers = decodedItems
                    return
                }
            }
            RolledNumbers = []
        }
    
    
}

struct PastNumber: Codable, Identifiable {
    var id = UUID()
    var number = 0
}
