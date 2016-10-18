//
//  GameOverScene.swift
//  SoloM
//
//  Created by Yulia Pashko on 21.09.16.
//  Copyright © 2016 Yulia Pashko. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let restartLable = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        
        // SKSpriteNode Game over background
        let background  = SKSpriteNode(imageNamed: "full-background.png")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        
        self.addChild(background)
        
        //SKLabelNode "Game Over"
        let gameOverLable = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLable.text = "Game Over"
        gameOverLable.fontSize = 200
        gameOverLable.fontColor = SKColor.orange
        gameOverLable.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameOverLable.zPosition = 1
        
        self.addChild(gameOverLable)
        
        //SKLabelNode "Score"
        let scoreLable = SKLabelNode(fontNamed: "The Bold Font")
        scoreLable.text = "Score: \(gameScore)"
        scoreLable.fontSize = 125
        scoreLable.fontColor = SKColor.white
        scoreLable.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.55)
        scoreLable.zPosition = 1
        
        self.addChild(scoreLable)
        
        //User defaults high score saved
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            
            }
        
        //SKLabelNode "High Score"
        let highScoreLable = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLable.text = "High Score: \(highScoreNumber)"
        highScoreLable.fontSize = 125
        highScoreLable.fontColor = SKColor.white
        highScoreLable.zPosition = 1
        highScoreLable.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        
        self.addChild(highScoreLable)
        
        //SKLabelNode "Restart"
        restartLable.text = "Restart"
        restartLable.fontSize = 90
        restartLable.fontColor = SKColor.green
        restartLable.zPosition = 1
        restartLable.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        
        self.addChild(restartLable)
        
        
        }
    
    // Restart update action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
           
            let pointOfTouch = touch.location(in: self)
            
            if restartLable.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
        }
    }
}
