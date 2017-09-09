//
//  GameController.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import Foundation
import SpriteKit

class GameManager {
    
    static let instance = GameManager()
    
    private init() {
        
    }
    
    var gameStartedFromMainMenu = false
    var gameRestartedPlayerDied = false
    
}
