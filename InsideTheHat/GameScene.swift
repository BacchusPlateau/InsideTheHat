//
//  GameScene.swift
//  InsideTheHat
//
//  Created by Bret Williams on 12/24/19.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var rabbit: SKSpriteNode!
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var wall : SKSpriteNode!
    private var leftDoor : SKSpriteNode!
    private var centerDoor : SKSpriteNode!
    private var rightDoor : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        self.initializeMainCharacter()
        self.initializeWall()
        self.initializeWallMovement()
        self.initializeDoors()
        
    }
    
    func distanceBetween(point p1: CGPoint, andPoint p2:CGPoint) -> CGFloat {
        return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    func initializeDoors() {
        
        
        
    }
    
    func initializeMainCharacter() {
        
        rabbit = SKSpriteNode(imageNamed: "rabbit")
        rabbit.position = CGPoint(x: (view!.bounds.size.width / 2), y: rabbit.size.height)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.zPosition = -1
        
        addChild(background)
        addChild(rabbit)
        
    }
    
    func initializeWall() {
        
        wall = SKSpriteNode(imageNamed: "wall")
        wall.position = CGPoint(x: (view!.bounds.size.width / 2), y: view!.bounds.size.height + wall.frame.size.height / 2)
        wall.zPosition = 2
        addChild(wall)
        
    }
    
    func initializeWallMovement() {
        
        let wallSpeed: CGFloat = 250.0
        let nextWallPosition = CGPoint(x: wall.position.x, y: -wall.frame.size.height / 2)
        let duration = self.distanceBetween(point: wall.position, andPoint: nextWallPosition) / wallSpeed
        let moveWallAction = SKAction.moveTo(y: nextWallPosition.y, duration: Double(duration))
        let resetPositionAction = SKAction.run {
            self.wall.position = CGPoint(x: (self.view!.bounds.size.width / 2), y: self.view!.bounds.size.height +
             self.wall.frame.size.height / 2)
        }
            
        let delayAction = SKAction.wait(forDuration: 2.0)
        let sequence = SKAction.sequence([moveWallAction, resetPositionAction, delayAction])
        
        wall.run(SKAction.repeatForever(sequence))
        
    }
    
    func moveRabbitToNextLocation(touchLocation: CGPoint) {
        
        let rabbitSpeed: CGFloat = 360.0
        var moveAction: SKAction!
        var duration: CGFloat = 0.0
        var nextPosition: CGPoint
        
        if touchLocation.x <= view!.bounds.size.width / 3 {
            nextPosition = CGPoint(x: view!.bounds.size.width / 6 + 25 * rabbit.frame.width / 40, y: rabbit.position.y)
        } else if touchLocation.x > view!.bounds.size.width / 3 && touchLocation.x <= 2 * view!.bounds.size.width / 3 {
            nextPosition = CGPoint(x: view!.bounds.size.width / 2, y: rabbit.position.y)
        } else {
            nextPosition = CGPoint(x: 5 * view!.bounds.size.width / 6 - 25 * rabbit.frame.width / 40, y: rabbit.position.y)
        }
        
        duration = self.distanceBetween(point: rabbit.position, andPoint: nextPosition) / rabbitSpeed
        moveAction = SKAction.moveTo(x: nextPosition.x, duration: Double(duration))
        
        rabbit.run(moveAction)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            if rabbit.hasActions() {
                rabbit.removeAllActions()
            }
            
            let location = touch.location(in: self)
            self.moveRabbitToNextLocation(touchLocation: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
