//
//  GameplayScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 8/31/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var cloudsController = CloudsController()
    
    var mainCamera: SKCameraNode?
    
    var bg1: BGClass?
    var bg2: BGClass?
    var bg3: BGClass?
    
    var player: Player?
    
    var canMove = false
    var moveLeft = false
    
    var center: CGFloat?
    
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
        center = self.scene!.size.width / self.scene!.size.height
        
        player = self.childNode(withName: "Player") as? Player
        player?.initializePlayerAndAnimations()
        
        mainCamera = self.childNode(withName: "Main Camera") as? SKCameraNode
        
        getBackgrounds()
        
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
        }
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
