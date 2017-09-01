//
//  GameplayScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 8/31/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var player: Player?
    
    var canMove = false
    var moveLeft = false
    
    var center: CGFloat?
    
    override func didMove(to view: SKView) {
        center = self.scene!.size.width / self.scene!.size.height
        
        // print("width: \(self.scene!.size.width), height: \(self.scene!.size.height)")
        
        player = self.childNode(withName: "Player") as? Player
    }
    
    override func update(_ currentTime: TimeInterval) {
        managePlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // print("x: \(location.x), y: \(location.y)")
            
            if location.x > center! {
                moveLeft = false
            } else {
                moveLeft = true
            }
        }
        
        canMove = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false
    }
    
    func managePlayer() {
        if canMove {
            player?.movePlayer(moveLeft: moveLeft)
        }
    }
    
}
