//
//  GameplayScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 8/31/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var mainCamera: SKCameraNode?
    
    var player: Player?
    
    var canMove = false
    var moveLeft = false
    
    var center: CGFloat?
    
    override func didMove(to view: SKView) {
        initializeVariables()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCamera()
        managePlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // print("x: \(location.x), y: \(location.y)")
            
            if location.x > 0 {
                moveLeft = false
                player?.animatePlayer(moveLeft: moveLeft)
            } else {
                moveLeft = true
                player?.animatePlayer(moveLeft: moveLeft)
            }
        }
        
        canMove = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false
        player?.stopPlayerAnimation()
    }
    
    func initializeVariables() {
        center = self.scene!.size.width / self.scene!.size.height
        
        player = self.childNode(withName: "Player") as? Player
        player?.initializePlayerAndAnimations()
        
        mainCamera = self.childNode(withName: "Main Camera") as? SKCameraNode
    }
    
    func managePlayer() {
        if canMove {
            player?.movePlayer(moveLeft: moveLeft)
        }
    }
    
    func moveCamera() {
        mainCamera?.position.y -= 3
    }
    
}
