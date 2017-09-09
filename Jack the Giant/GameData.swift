//
//  GameData.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/9/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import Foundation

class GameData: NSObject, NSCoding {
    
    struct Keys {
        static let easyDifficultyScore = "easyDifficultyScore"
        static let mediumDifficultyScore = "mediumDifficultyScore"
        static let hardDifficultyScore = "hardDifficultyScore"
        
        static let easyDifficultyCoinScore = "easyDifficultyCoinScore"
        static let mediumDifficultyCoinScore = "mediumDifficultyCoinScore"
        static let hardDifficultyCoinScore = "hardDifficultyCoinScore"
        
        static let easyDifficulty = "easyDifficulty"
        static let mediumDifficulty = "mediumDifficulty"
        static let hardDifficulty = "hardDifficulty"
        
        static let isMusicOn = "isMusicOn"
    }
    
    private var easyDifficultyScore = Int32()
    private var mediumDifficultyScore = Int32()
    private var hardDifficultyScore = Int32()
    
    private var easyDifficultyCoinScore = Int32()
    private var mediumDifficultyCoinScore = Int32()
    private var hardDifficultyCoinScore = Int32()

    private var easyDifficulty = false
    private var mediumDifficulty = false
    private var hardDifficulty = false

    private var isMusicOn = false
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.easyDifficultyScore = aDecoder.decodeInt32(forKey: Keys.easyDifficultyScore)
        self.mediumDifficultyScore = aDecoder.decodeInt32(forKey: Keys.mediumDifficultyScore)
        self.hardDifficultyScore = aDecoder.decodeInt32(forKey: Keys.hardDifficultyScore)
        
        self.easyDifficultyCoinScore = aDecoder.decodeInt32(forKey: Keys.easyDifficultyCoinScore)
        self.mediumDifficultyCoinScore = aDecoder.decodeInt32(forKey: Keys.mediumDifficultyCoinScore)
        self.hardDifficultyCoinScore = aDecoder.decodeInt32(forKey: Keys.hardDifficultyCoinScore)
        
        self.easyDifficulty  = aDecoder.decodeBool(forKey: Keys.easyDifficulty)
        self.mediumDifficulty = aDecoder.decodeBool(forKey: Keys.mediumDifficulty)
        self.hardDifficulty = aDecoder.decodeBool(forKey: Keys.hardDifficulty)
        
        self.isMusicOn = aDecoder.decodeBool(forKey: Keys.isMusicOn)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.easyDifficultyScore, forKey: Keys.easyDifficultyScore)
        aCoder.encode(self.mediumDifficultyScore, forKey: Keys.mediumDifficultyScore)
        aCoder.encode(self.hardDifficultyScore, forKey: Keys.hardDifficultyScore)
        
        aCoder.encode(self.easyDifficultyCoinScore, forKey: Keys.easyDifficultyCoinScore)
        aCoder.encode(self.mediumDifficultyCoinScore, forKey: Keys.mediumDifficultyCoinScore)
        aCoder.encode(self.hardDifficultyCoinScore, forKey: Keys.hardDifficultyCoinScore)
        
        aCoder.encode(self.easyDifficulty, forKey: Keys.easyDifficulty)
        aCoder.encode(self.mediumDifficulty, forKey: Keys.mediumDifficulty)
        aCoder.encode(self.hardDifficulty, forKey: Keys.hardDifficulty)
        
        aCoder.encode(self.isMusicOn, forKey: Keys.isMusicOn)
    }
    
    func setEasyDifficultyScore(_ easyDifficultyScore: Int32) {
        self.easyDifficultyScore = easyDifficultyScore;
    }
    
    func setEasyDifficultyCoinScore(_ easyDifficultyCoinScore: Int32) {
        self.easyDifficultyCoinScore = easyDifficultyCoinScore;
    }
    
    func getEasyDifficultyScore() -> Int32 {
        return self.easyDifficultyScore;
    }
    
    func getEasyDifficultyCoinScore() -> Int32 {
        return self.easyDifficultyCoinScore;
    }
    
    func setMediumDifficultyScore(_ mediumDifficultyScore: Int32) {
        self.mediumDifficultyScore = mediumDifficultyScore;
    }
    
    func setMediumDifficultyCoinScore(_ mediumDifficultyCoinScore: Int32) {
        self.mediumDifficultyCoinScore = mediumDifficultyCoinScore;
    }
    
    func getMediumDifficultyScore() -> Int32 {
        return self.mediumDifficultyScore;
    }
    
    func getMediumDifficultyCoinScore() -> Int32 {
        return self.mediumDifficultyCoinScore;
    }
    
    func setHardDifficultyScore(_ hardDifficultyScore: Int32) {
        self.hardDifficultyScore = hardDifficultyScore;
    }
    
    func setHardDifficultyCoinScore(_ hardDifficultyCoinScore: Int32) {
        self.hardDifficultyCoinScore = hardDifficultyCoinScore;
    }
    
    func getHardDifficultyScore() -> Int32 {
        return self.hardDifficultyScore;
    }
    
    func getHardDifficultyCoinScore() -> Int32 {
        return self.hardDifficultyCoinScore;
    }
    
    func setEasyDifficulty(_ easyDifficulty: Bool) {
        self.easyDifficulty = easyDifficulty;
    }
    
    func getEasyDifficulty() -> Bool {
        return self.easyDifficulty;
    }
    
    func setMediumDifficulty(_ mediumDifficulty: Bool) {
        self.mediumDifficulty = mediumDifficulty;
    }
    
    func getMediumDifficulty() -> Bool {
        return self.mediumDifficulty;
    }
    
    func setHardDifficulty(_ hardDifficulty: Bool) {
        self.hardDifficulty = hardDifficulty;
    }
    
    func getHardDifficulty() -> Bool {
        return self.hardDifficulty;
    }
    
    func setIsMusicOn(_ isMusicOn: Bool) {
        self.isMusicOn = isMusicOn;
    }
    
    func getIsMusicOn() -> Bool {
        return self.isMusicOn;
    }
    
}
