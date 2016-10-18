//
//  GameScene.swift
//  SoloM
//
//  Created by Yulia Pashko on 18.09.16.
//  Copyright © 2016 Yulia Pashko. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Global variables
    
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
        var liveNumber = 3
    
        let livesLable = SKLabelNode(fontNamed: "The Bold Font")
    
        var levelNumber = 0
        
        let player = SKSpriteNode(imageNamed: "DurrrSpaceShip.png")
        
        let bulletSound = SKAction.playSoundFileNamed("bulletSoundEffect-0-0.5.mp3", waitForCompletion: false)
        
        let explosionSound = SKAction.playSoundFileNamed("enemyeEplosion.mp3", waitForCompletion: false)
    
        let tapToStartLable = SKLabelNode(fontNamed: "The Bold Font")
    
    //game status
    enum gameState{
        
        case preGame
        case inGame
        case afterGame
        
    }
    
    var currentGameState = gameState.preGame
    
    //game bit mask
    struct PhysicsCategories {
        
        static let none: UInt32 = 0       //1
        static let player: UInt32 = 0b1   //2
        static let bullet: UInt32 = 0b10  //3
        static let enemy: UInt32 = 0b100  //4
        
    }
    
    //create random enemis ships
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    
    
    var gameArea: CGRect
    
    //game area size
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1{
        
        // SKSpriteNode main play game background
        let background = SKSpriteNode(imageNamed: "full-background4.png")
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
        background.zPosition = 0
        background.name = "Background"
            
        self.addChild(background)
        
        }
        
        //SKSpriteNode create player ship and physics contact with enemy
        player.setScale(2.8)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.player
        player.physicsBody!.collisionBitMask = PhysicsCategories.none
        player.physicsBody!.contactTestBitMask = PhysicsCategories.enemy
        
        self.addChild(player)
        
        //SKLableNode "Score" in game
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        
        self.addChild(scoreLabel)
        
        //SKLableNode "Lives" in game
        livesLable.text = "Lives: 3"
        livesLable.fontSize = 70
        livesLable.fontColor = SKColor.white
        livesLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLable.position = CGPoint(x: self.size.width * 0.85, y: self.size.height + livesLable.frame.size.height)
        livesLable.zPosition = 100
        
        self.addChild(livesLable)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLable.run(moveOnToScreenAction)
        
        //SKLableNode "Let's go!"
        tapToStartLable.text = "Let's Go!"
        tapToStartLable.fontSize = 200
        tapToStartLable.fontColor = SKColor.yellow
        tapToStartLable.zPosition = 1
        tapToStartLable.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tapToStartLable.alpha = 0
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLable.run(fadeInAction)
        
        self.addChild(tapToStartLable)
        
        }
   
    //scroll screen
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background") { (background, stop) in
            
            if self.currentGameState == gameState.inGame{
            background.position.y  -= amountToMoveBackground
            }
            if background.position.y < -self.size.height{
                
                background.position.y += self.size.height * 2
            }
        }
        
    }
    
    
    func startGame(){
        
        
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLable.run(deleteSequence)
        
        let moveShipOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOnToScreenAction, startLevelAction])
        player.run(startGameSequence)
        
        
        }
    
    
    
    func loseALife(){
        
        liveNumber -= 1
        livesLable.text = "Lives: \(liveNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLable.run(scaleSequence)
        
        if liveNumber == 0{
            runGameOver()
        }
        
    }
    
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore  == 25 || gameScore == 50{
        startNewLevel()
     }
    }
    
    

    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Enemy") { enemy, stop in
            
            enemy.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy2") { enemy2, stop in
            
            enemy2.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Bullet") { bullet, stop in
            
            bullet.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run {
            self.changeScene()
        }
        
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        
        let changeScenceSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeScenceSequence)
        
    }
    
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
        }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.player &&
            body2.categoryBitMask == PhysicsCategories.enemy{
            //if the player has hit the enemy
            if body1.node != nil{
            spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
             runGameOver()
        }
        
        if body1.categoryBitMask == PhysicsCategories.bullet &&
            body2.categoryBitMask == PhysicsCategories.enemy && (body2.node?.position.y)! < self.size.height{
            //if the bullet has hit the enemy
            addScore()
            
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        
        let explosion  = SKSpriteNode(imageNamed: "64_boom.png")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOunt = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn, fadeOunt, delete])
        
        explosion.run(explosionSequence)
        
    }
    
    
    func fireBullet(){
        
        //SKSpriteNode create bullet
        let bullet = SKSpriteNode(imageNamed: "beams.png")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        
        //physic cintact with bullet and enemy
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.none
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.enemy
        
       self.addChild(bullet)
        
        
        let moveBullet = SKAction.moveTo(y: self.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        
        if currentGameState == gameState.inGame{
        bullet.run(bulletSequence)
        }
    }
    
    func spawnEnemy(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        //Enemy create 1
        let enemy = SKSpriteNode(imageNamed: "64_1.png")
        enemy.name = "Enemy"
        enemy.setScale(0.7)
        enemy.position = startPoint
        enemy.zPosition = 2
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.none
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.player | PhysicsCategories.bullet
        
        
        self.addChild(enemy)
        
        //Enemy create 2
        let enemy2 = SKSpriteNode(imageNamed: "asteroid.png")
        enemy2.name = "Enemy2"
        enemy2.setScale(1.5)
        enemy2.position = startPoint
        enemy2.zPosition = 1
        
        enemy2.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy2.physicsBody!.affectedByGravity = false
        enemy2.physicsBody!.categoryBitMask = PhysicsCategories.enemy
        enemy2.physicsBody!.collisionBitMask = PhysicsCategories.none
        enemy2.physicsBody!.contactTestBitMask = PhysicsCategories.player | PhysicsCategories.bullet
        
        self.addChild(enemy2)

        //Move enemy 1
        let moveEnemy = SKAction.move(to: endPoint, duration: 2.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseAlifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseAlifeAction])
        
        
        if currentGameState == gameState.inGame{
        enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
        
        //Move enemy 2
        let moveEnemy2 = SKAction.move(to: endPoint, duration: 7)
        let deleteEnemy2 = SKAction.removeFromParent()
        let loseAlifeAction2 = SKAction.run(loseALife)
        let enemySequence2 = SKAction.sequence([moveEnemy2, deleteEnemy2, loseAlifeAction2])
        
        if currentGameState == gameState.inGame{
        enemy2.run(enemySequence2)
        }
        
        
        let dx1 = endPoint.x - startPoint.x
        let dy1 = endPoint.y - startPoint.y
        let amountToRotate1 = atan2(dy1, dx1)
        enemy2.zRotation = amountToRotate1

        
    }
    
    func startNewLevel(){
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 2.5
        case 2: levelDuration = 1.5
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
            
        default:
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
        }
        
       else if currentGameState == gameState.inGame{
        fireBullet()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame{
            player.position.x += amountDragged
            }
            
            //player ship position in game area
            if player.position.x > gameArea.maxX - player.size.width / 2 {
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            
            if player.position.x < gameArea.minX + player.size.width / 2 {
                player.position.x  = gameArea.minX + player.size.width / 2
            }
            
        }
    }
}

