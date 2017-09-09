//
//  GameplayScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 8/31/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    var cloudsController = CloudsController()
    
    var mainCamera: SKCameraNode?
    
    var bg1: BGClass?
    var bg2: BGClass?
    var bg3: BGClass?
    
    var player: Player?
    
    var canMove = false
    var moveLeft = false
    
    var center: CGFloat?
    
    private let playerMinX = CGFloat(-214)
    private let playerMaxX = CGFloat(214)
    
    private var cameraDistanceBeforeCreatingNewClouds: CGFloat = 0
    
    let distanceBetweenClouds: CGFloat = 240
    let minX: CGFloat = -160
    let maxX: CGFloat = 160
    
    var pauseButton: SKSpriteNode?
    private var pausePanel: SKSpriteNode?
        
    override func didMove(to view: SKView) {
        initializeVariables()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCamera()
        managePlayer()
        manageBackgrounds()
        createNewClouds()
        
        player?.updateScore()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Life" {
            // Play the sound for the life
            
            // Increment the life score
            GameplayController.instance.incrementLife()
            
            // Remove the life
            secondBody.node?.removeFromParent()
        } else if firstBody.node?.name == "Player" && secondBody.node?.name == "Coin" {
            // Play the sound for the coin
            
            // Increment the coin score
            GameplayController.instance.incrementCoin()
            
            // Remove the coin
            secondBody.node?.removeFromParent()
        } else if firstBody.node?.name == "Player" && secondBody.node?.name == "Dark Cloud" {
            // Kill the player
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let nodes = self.nodes(at: location)
            
            if self.nodes(at: location).contains(pauseButton!) {
                self.scene?.isPaused = true
                createPausePanel()
            } else if nodes.count > 0 && nodes[0].name == "Resume" {
                pausePanel?.removeFromParent()
                self.scene?.isPaused = false
                return
            } else if  nodes.count > 0 && nodes[0].name == "Quit" {
                let scene = MainMenuScene(fileNamed: "MainMenuScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.crossFade(withDuration: 1))
            }
            
            if self.scene?.isPaused == false {
                if location.x > center! {
                    moveLeft = false
                    player?.animatePlayer(moveLeft: moveLeft)
                } else {
                    moveLeft = true
                    player?.animatePlayer(moveLeft: moveLeft)
                }
            }
        }
        
        canMove = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false
        player?.stopPlayerAnimation()
    }
    
    func initializeVariables() {
        physicsWorld.contactDelegate = self
        
        center = self.scene!.size.width / self.scene!.size.height
        
        player = self.childNode(withName: "Player") as? Player
        player?.initializePlayerAndAnimations()
        
        mainCamera = self.childNode(withName: "Main Camera") as? SKCameraNode
        
        getBackgrounds()
        
        getLables()
        
        GameplayController.instance.initializeVariables()
        
        cloudsController.arrangeCloudsInScene(
            scene: self.scene!,
            distanceBetweenClouds: distanceBetweenClouds,
            center: center!,
            minX: minX,
            maxX: maxX,
            initialClouds: true)
        
        cameraDistanceBeforeCreatingNewClouds = (mainCamera?.position.y)! - 400
        
        let lifeScore = mainCamera!.childNode(withName: "Life Score") as! SKLabelNode
        lifeScore.fontName = "Blow"
        lifeScore.fontSize = 36
        
        let coinScore = mainCamera!.childNode(withName: "Coin Score") as! SKLabelNode
        coinScore.fontName = "Blow"
        coinScore.fontSize = 36

        let scoreText = mainCamera!.childNode(withName: "Score Text") as! SKLabelNode
        scoreText.fontName = "Blow"
        scoreText.fontSize = 36
        
        pauseButton = mainCamera!.childNode(withName: "Pause Button") as? SKSpriteNode
    }
    
    func getBackgrounds() {
        bg1 = self.childNode(withName: "BG 1") as? BGClass
        bg2 = self.childNode(withName: "BG 2") as? BGClass
        bg3 = self.childNode(withName: "BG 3") as? BGClass
    }
    
    func managePlayer() {
        if canMove {
            player?.movePlayer(moveLeft: moveLeft)
        }
        
        if (player?.position.x)! > playerMaxX {
            player?.position.x = playerMaxX
        }
        
        if (player?.position.x)! < playerMinX {
            player?.position.x = playerMinX
        }
        
        if (player?.position.y)! - (player?.size.height)! * 3.7 > (mainCamera?.position.y)! {
            print("The player is out of bounds up")
            self.scene?.isPaused = true
        }
        
        if (player?.position.y)! + (player?.size.height)! * 3.7 < (mainCamera?.position.y)! {
            print("The player is out of bounds down")
            self.scene?.isPaused = true
        }
    }
    
    func moveCamera() {
        mainCamera?.position.y -= 3
    }
    
    func manageBackgrounds() {
        bg1?.moveBG(camera: mainCamera!)
        bg2?.moveBG(camera: mainCamera!)
        bg3?.moveBG(camera: mainCamera!)
    }
    
    func createNewClouds() {
        if cameraDistanceBeforeCreatingNewClouds > (mainCamera?.position.y)! {
            cameraDistanceBeforeCreatingNewClouds = (mainCamera?.position.y)! - 400
            
            cloudsController.arrangeCloudsInScene(scene: self.scene!, distanceBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, initialClouds: false)
            
            checkForChildrenOutOffScreen()
        }
    }
    
    func checkForChildrenOutOffScreen() {
        for child in self.children {
            if child.position.y > (mainCamera?.position.y)! + (self.scene?.size.height)! {
                let childNameComponents = child.name?.components(separatedBy: " ")
                
                if childNameComponents?[0] != "BG" {
                    print("The child that was removed is \(child.name!)")
                    child.removeFromParent()
                }
            }
        }
    }
    
    func getLables() {
        GameplayController.instance.scoreText = mainCamera!.childNode(withName: "Score Text") as? SKLabelNode
        GameplayController.instance.coinText = mainCamera!.childNode(withName: "Coin Score") as? SKLabelNode
        GameplayController.instance.lifeText = mainCamera!.childNode(withName: "Life Score") as? SKLabelNode
    }
    
    func createPausePanel() {
        pausePanel = SKSpriteNode(imageNamed: "Pause Menu")
        let resumeButton = SKSpriteNode(imageNamed: "Resume Button")
        let quitButton = SKSpriteNode(imageNamed: "Quit Button 2")
        
        pausePanel?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pausePanel?.xScale = 1.6
        pausePanel?.yScale = 1.6
        pausePanel?.zPosition = 5
        
        pausePanel?.position = CGPoint(
            x: (self.mainCamera?.frame.size.width)! / 2,
            y: (self.mainCamera?.frame.height)! / 2)
        
        resumeButton.name = "Resume"
        resumeButton.zPosition = 6
        resumeButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        resumeButton.position = CGPoint(x: (pausePanel?.position.x)!, y: (pausePanel?.position.y)! + 25)
        
        quitButton.name = "Quit"
        quitButton.zPosition = 6
        quitButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quitButton.position = CGPoint(x: (pausePanel?.position.x)!, y: (pausePanel?.position.y)! - 45)
        
        pausePanel?.addChild(resumeButton)
        pausePanel?.addChild(quitButton)
        
        self.mainCamera?.addChild(pausePanel!)
    }
    
}
