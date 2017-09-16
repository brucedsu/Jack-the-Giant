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
    
    private var acceleration = CGFloat()
    private var cameraSpeed = CGFloat()
    private var maxSpeed =  CGFloat()
    
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
            if GameManager.instance.getIsMusicOn() {
                self.run(SKAction.playSoundFileNamed("Life Sound.wav", waitForCompletion: false))
            }
            
            // Increment the life score
            GameplayController.instance.incrementLife()
            
            // Remove the life
            secondBody.node?.removeFromParent()
        } else if firstBody.node?.name == "Player" && secondBody.node?.name == "Coin" {
            // Play the sound for the coin
            if GameManager.instance.getIsMusicOn() {
                self.run(SKAction.playSoundFileNamed("Coin Sound.wav", waitForCompletion: false))
            }
            
            // Increment the coin score
            GameplayController.instance.incrementCoin()
            
            // Remove the coin
            secondBody.node?.removeFromParent()
        } else if firstBody.node?.name == "Player" && secondBody.node?.name == "Dark Cloud" {
            // Kill the player
            self.scene?.isPaused = true
            
            GameplayController.instance.life! -= 1
            
            if GameplayController.instance.life! >= 0 {
                GameplayController.instance.lifeText?.text = "x\(GameplayController.instance.life!)"
            } else {
                // Show end score panel
                createEndScorePanel()
            }
            
            firstBody.node?.removeFromParent()
            
            Timer.scheduledTimer(
                timeInterval: 1.5,
                target: self,
                selector: #selector(GameplayScene.playerDied),
                userInfo: nil,
                repeats: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let nodes = self.nodes(at: location)
            
            if self.nodes(at: location).contains(pauseButton!) && self.scene?.isPaused == false {
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
            player: player!,
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
        
        setCameraSpeed()
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
            
            GameplayController.instance.life! -= 1
            
            if GameplayController.instance.life! >= 0 {
                GameplayController.instance.lifeText?.text = "x\(GameplayController.instance.life!)"
            } else {
                // Show end score panel
                createEndScorePanel()
            }
            
            Timer.scheduledTimer(
                timeInterval: 1.5,
                target: self,
                selector: #selector(GameplayScene.playerDied),
                userInfo: nil,
                repeats: false)
        }
        
        if (player?.position.y)! + (player?.size.height)! * 3.7 < (mainCamera?.position.y)! {
            print("The player is out of bounds down")
            
            self.scene?.isPaused = true
            
            GameplayController.instance.life! -= 1
            
            if GameplayController.instance.life! >= 0 {
                GameplayController.instance.lifeText?.text = "x\(GameplayController.instance.life!)"
            } else {
                // Show end score panel
                createEndScorePanel()
            }
            
            Timer.scheduledTimer(
                timeInterval: 1.5,
                target: self,
                selector: #selector(GameplayScene.playerDied),
                userInfo: nil,
                repeats: false)
        }
    }
    
    func moveCamera() {
        cameraSpeed += acceleration
        
        if cameraSpeed > maxSpeed {
            cameraSpeed = maxSpeed
        }
        
        mainCamera?.position.y -= cameraSpeed
    }
    
    func manageBackgrounds() {
        bg1?.moveBG(camera: mainCamera!)
        bg2?.moveBG(camera: mainCamera!)
        bg3?.moveBG(camera: mainCamera!)
    }
    
    func createNewClouds() {
        if cameraDistanceBeforeCreatingNewClouds > (mainCamera?.position.y)! {
            cameraDistanceBeforeCreatingNewClouds = (mainCamera?.position.y)! - 400
            
            cloudsController.arrangeCloudsInScene(
                scene: self.scene!,
                distanceBetweenClouds: distanceBetweenClouds,
                center: center!,
                minX: minX,
                maxX: maxX,
                player: player!,
                initialClouds: false)
            
            checkForChildrenOutOffScreen()
        }
    }
    
    func checkForChildrenOutOffScreen() {
        for child in self.children {
            if child.position.y > (mainCamera?.position.y)! + (self.scene?.size.height)! {
                let childNameComponents = child.name?.components(separatedBy: " ")
                
                if childNameComponents?[0] != "BG" {
                    // print("The child that was removed is \(child.name!)")
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
    
    func createEndScorePanel() {
        let endScorePanel = SKSpriteNode(imageNamed: "Show Score")
        let scoreLabel = SKLabelNode(fontNamed: "Blow")
        let coinLabel = SKLabelNode(fontNamed: "Blow")

        endScorePanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        endScorePanel.zPosition = 8
        endScorePanel.xScale = 1.5
        endScorePanel.yScale = 1.5
        
        scoreLabel.fontSize = 50
        scoreLabel.zPosition = 7
        
        coinLabel.fontSize = 50
        coinLabel.zPosition = 7
        
        scoreLabel.text = "\(GameplayController.instance.score!)"
        coinLabel.text = "\(GameplayController.instance.coin!)"
        
        endScorePanel.position = CGPoint(
            x: (mainCamera?.frame.size.width)! / 2,
            y: (mainCamera?.frame.size.height)! / 3)
        
        scoreLabel.position = CGPoint(x: endScorePanel.position.x - 60, y: endScorePanel.position.y + 10)
        coinLabel.position = CGPoint(x: endScorePanel.position.x - 60, y: endScorePanel.position.y - 105)
        
        endScorePanel.addChild(scoreLabel)
        endScorePanel.addChild(coinLabel)
        
        mainCamera?.addChild(endScorePanel)
    }
    
    private func setCameraSpeed() {
        if GameManager.instance.getEasyDifficulty() == true {
            acceleration = 0.001
            cameraSpeed = 1.5
            maxSpeed = 4
        } else if GameManager.instance.getMediumDifficulty() == true {
            acceleration = 0.002
            cameraSpeed = 2.0
            maxSpeed = 6
        } else if GameManager.instance.getHardDifficulty() == true {
            acceleration = 0.003
            cameraSpeed = 2.5
            maxSpeed = 8
        }
    }
    
    func playerDied() {
        if GameplayController.instance.life! >= 0 {
            GameManager.instance.gameRestartedPlayerDied = true
            
            let scene = GameplayScene(fileNamed: "GameplayScene")
            scene!.scaleMode = .aspectFill
            self.view?.presentScene(
                scene!,
                transition: SKTransition.crossFade(withDuration: 1))
        } else {
            if GameManager.instance.getEasyDifficulty() {
                let highScore = GameManager.instance.getEasyDifficultyScore()
                let coinScore = GameManager.instance.getEasyDifficultyCoinScore()
                
                if highScore < GameplayController.instance.score! {
                    GameManager.instance.setEasyDifficultyScore(GameplayController.instance.score!)
                }
                
                if coinScore < GameplayController.instance.coin! {
                    GameManager.instance.setEasyDifficultyCoinScore(GameplayController.instance.coin!)
                }
            } else if GameManager.instance.getMediumDifficulty() {
                let highScore = GameManager.instance.getMediumDifficultyScore()
                let coinScore = GameManager.instance.getMediumDifficultyCoinScore()
                
                if highScore < GameplayController.instance.score! {
                    GameManager.instance.setMediumDifficultyScore(GameplayController.instance.score!)
                }
                
                if coinScore < GameplayController.instance.coin! {
                    GameManager.instance.setMediumDifficultyCoinScore(GameplayController.instance.coin!)
                }
            } else if GameManager.instance.getHardDifficulty() {
                let highScore = GameManager.instance.getHardDifficultyScore()
                let coinScore = GameManager.instance.getHardDifficultyCoinScore()
                
                if highScore < GameplayController.instance.score! {
                    GameManager.instance.setHardDifficultyScore(GameplayController.instance.score!)
                }
                
                if coinScore < GameplayController.instance.coin! {
                    GameManager.instance.setHardDifficultyCoinScore(GameplayController.instance.coin!)
                }
            }
            
            GameManager.instance.saveData()
            
            let scene = MainMenuScene(fileNamed: "MainMenuScene")
            scene!.scaleMode = .aspectFill
            self.view?.presentScene(
                scene!,
                transition: SKTransition.crossFade(withDuration: 1))
        }
    }
    
}
