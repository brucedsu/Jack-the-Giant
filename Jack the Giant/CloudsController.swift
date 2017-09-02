//
//  CloudsController.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/1/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class CloudsController {
    
    var lastCloudPositionY = CGFloat()
    
    func shuffle(_ cloudsArray: inout [SKSpriteNode]) -> [SKSpriteNode] {
        for i in (0..<cloudsArray.count - 1).reversed() {
            var j = 0
            
            while (j == i) {
                j = Int(arc4random_uniform(UInt32(cloudsArray.count - 1)))
            }
            
            swap(&cloudsArray[i], &cloudsArray[j])
        }
        
        return cloudsArray
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func createClouds() -> [SKSpriteNode] {
        var clouds = [SKSpriteNode]()
        
        for _ in 0 ..< 2 {
            let cloud1 = SKSpriteNode(imageNamed: "Cloud 1")
            cloud1.name = "1"
            let cloud2 = SKSpriteNode(imageNamed: "Cloud 2")
            cloud2.name = "2"
            let cloud3 = SKSpriteNode(imageNamed: "Cloud 3")
            cloud3.name = "3"
            let darkCloud = SKSpriteNode(imageNamed: "Dark Cloud")
            darkCloud.name = "Dark Cloud"

            cloud1.xScale = 0.9
            cloud1.yScale = 0.9
            
            cloud2.xScale = 0.9
            cloud2.yScale = 0.9
            
            cloud3.xScale = 0.9
            cloud3.yScale = 0.9
            
            darkCloud.xScale = 0.9
            darkCloud.yScale = 0.9
            
            // Add physics bodies
            
            clouds.append(cloud1)
            clouds.append(cloud2)
            clouds.append(cloud3)
            clouds.append(darkCloud)
        }
        
        clouds = shuffle(&clouds)
        
        return clouds
    }
    
    func arrangeCloudsInScene(scene: SKScene, distanceBetweenClouds: CGFloat, center: CGFloat, minX: CGFloat, maxX: CGFloat, initialClouds: Bool) {
        var clouds = createClouds()
        
        if initialClouds {
            while clouds[0].name == "Dark Cloud" {
                clouds = shuffle(&clouds)
            }
        }
        
        var positionY = CGFloat()
        
        if initialClouds {
            positionY = center - 100
        } else {
            positionY = lastCloudPositionY
        }
        
        for i in 0...clouds.count - 1 {
            clouds[i].position = CGPoint(x: 0, y: positionY)
            clouds[i].zPosition = 3
            
            scene.addChild(clouds[i])
            positionY -= distanceBetweenClouds
            lastCloudPositionY = positionY
        }
    }
    
}
