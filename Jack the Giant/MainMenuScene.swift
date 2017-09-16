//
//  MainMenuScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var startGameButton: SKSpriteNode?
    var highScoreButton: SKSpriteNode?
    var optionButton: SKSpriteNode?
    
    var musicButton: SKSpriteNode?
    private let musicOnTexture = SKTexture(imageNamed: "Music On Button")
    private let musicOffTexture = SKTexture(imageNamed: "Music Off Button")
    
    override func didMove(to view: SKView) {
        startGameButton = self.childNode(withName: "Start Game") as? SKSpriteNode
        highScoreButton = self.childNode(withName: "High Score") as? SKSpriteNode
        optionButton = self.childNode(withName: "Options") as? SKSpriteNode
        
        musicButton = self.childNode(withName: "Music Button") as? SKSpriteNode
        
        GameManager.instance.initializeGameData()
        
        setMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if self.nodes(at: location).contains(startGameButton!) {
                GameManager.instance.gameStartedFromMainMenu = true
                
                let scene = GameplayScene(fileNamed: "GameplayScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.crossFade(withDuration: 1))
            } else if self.nodes(at: location).contains(highScoreButton!) {
                let scene = HighScoreScene(fileNamed: "HighScoreScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.doorsOpenVertical(withDuration: 1))
            } else if self.nodes(at: location).contains(optionButton!) {
                let scene = OptionScene(fileNamed: "OptionScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.flipHorizontal(withDuration: 1))
            } else if self.nodes(at: location).contains(musicButton!) {
                handleMusicButton()
            }
        }
    }
    
    private func setMusic() {
        if GameManager.instance.getIsMusicOn() {
            if !AudioManager.instance.isAudioPlayerInitialized() {
                AudioManager.instance.playBGMusic()
            }
            
            musicButton?.texture = musicOnTexture
        } else {
            musicButton?.texture = musicOffTexture
        }
    }
    
    private func handleMusicButton() {
        if GameManager.instance.getIsMusicOn() {
            // The music is playing, turn it off
            AudioManager.instance.stopBGMusic()
            GameManager.instance.setIsMusicOn(false)
            musicButton?.texture = musicOffTexture
        } else {
            // The music is not playing, turn it on
            AudioManager.instance.playBGMusic()
            GameManager.instance.setIsMusicOn(true)
            musicButton?.texture = musicOnTexture
        }
        
        GameManager.instance.saveData()
    }
    
}
