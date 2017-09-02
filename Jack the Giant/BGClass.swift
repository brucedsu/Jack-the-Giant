//
//  BGClass.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/1/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class BGClass: SKSpriteNode {

    func moveBG(camera: SKCameraNode) {
        if self.position.y - self.size.height - 10 > camera.position.y {
            self.position.y -= self.size.height * 3
        }
    }
    
}
