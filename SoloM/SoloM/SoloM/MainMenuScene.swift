//
//  MainMenuScene.swift
//  SoloM
//
//  Created by Yulia Pashko on 22.09.16.
//  Copyright © 2016 Yulia Pashko. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    let startGame = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        
        //Start background in game
        let background = SKSpriteNode(imageNamed: "full-background2.png")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        
        self.addChild(background)
        
        //SKLabelNode game author
        let gameBy = SKLabelNode(fontNamed: "The Bold Font")
        gameBy.text = "Juli Pashko"
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.yellow
        gameBy.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.78)
        gameBy.zPosition = 1
        
        self.addChild(gameBy)
        
        //SKLabelNode game name 1
        let gameName1 = SKLabelNode(fontNamed: "The Bold Font")
        gameName1.text = "Space"
        gameName1.fontSize = 200
        gameName1.fontColor = SKColor.yellow
        gameName1.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.70)
        gameName1.zPosition = 1
        
        self.addChild(gameName1)
        
        //SKLabelNode game name 2
        let gameName2 = SKLabelNode(fontNamed: "The Bold Font")
        gameName2.text = "Battle"
        gameName2.fontSize = 200
        gameName2.fontColor = SKColor.yellow
        gameName2.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.625)
        gameName2.zPosition = 1
        
        self.addChild(gameName2)
        
        //SKLabelNode start game
        startGame.text = "Start Game"
        startGame.fontSize = 150
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.380)
        startGame.zPosition = 1
    
        self.addChild(startGame)
        
        }
    
    //Start game Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if startGame.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
        }
    }
}








    
    
