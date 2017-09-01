//
//  Player.swift
//  Jack the Giant
//
//  Created by Hejia Su on 8/31/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    func movePlayer(moveLeft: Bool) {
        if moveLeft {
            self.position.x -= 7
        } else {
            self.position.x += 7
        }
    }
    
}
