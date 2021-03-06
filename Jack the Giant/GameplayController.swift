//
//  GameplayController.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import Foundation
import SpriteKit

class GameplayController {

    static let instance = GameplayController()
    
    private init() {
        
    }
    
    var scoreText: SKLabelNode?
    var coinText: SKLabelNode?
    var lifeText: SKLabelNode?
    
    var score: Int32?
    var coin: Int32?
    var life: Int32?
    
    func initializeVariables() {
        if GameManager.instance.gameStartedFromMainMenu {
            GameManager.instance.gameStartedFromMainMenu = false
            
            score = -1
            coin = 0
            life = 2
            
            scoreText?.text = "\(score!)"
            coinText?.text = "x\(coin!)"
            lifeText?.text = "x\(life!)"
        } else if GameManager.instance.gameRestartedPlayerDied {
            GameManager.instance.gameRestartedPlayerDied = false
            
            scoreText?.text = "\(score!)"
            coinText?.text = "x\(coin!)"
            lifeText?.text = "x\(life!)"
        }
    }
    
    func incrementScore() {
        score! += 1
        scoreText?.text = "\(score!)"
    }
    
    func incrementCoin() {
        coin! += 1
        score! += 200
        coinText?.text = "x\(coin!)"
        scoreText?.text = "\(score!)"
    }
    
    func incrementLife() {
        life! += 1
        score! += 300
        lifeText?.text = "x\(life!)"
        scoreText?.text = "\(score!)"
    }
    
}
