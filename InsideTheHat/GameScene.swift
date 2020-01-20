//
//  GameScene.swift
//  InsideTheHat
//
//  Created by Bret Williams on 12/24/19.
//

//bugs:
//1. background doesn't fill entire screen - there is a black rectangle at the top
//2. score doesn't increase

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
    private var isCollisionDetected : Bool = false
    private var labelScore : SKLabelNode!
    private var resetWave : Bool = false
    private var score : Int = 0
    
    func detectCollisions() {
        
        self.enumerateChildNodes(withName: "*_door") {
            
            node, stop in
            
            //after the && we want to check to make sure at least half of the door has intersected the rabbit before triggering the collision
            if node.frame.intersects(self.rabbit.frame) && (node.position.y - node.frame.height / 2) <= self.rabbit.position.y {
                
                if node.name?.contains("wrong") == true {
                    
                    self.isCollisionDetected = true
                    let blinkAction = SKAction.sequence([
                        SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.5, duration: 0.1),
                        SKAction.fadeAlpha(to: 0.0, duration: 0.2),
                        SKAction.fadeAlpha(to: 1.0, duration: 0.2),
                        SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 0.1)
                    ])
                    self.rabbit.run(SKAction.repeat(blinkAction, count: 3))
                    
                }
                node.isHidden = true
            }
            
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        self.initializeMainCharacter()
        self.initializeWall()
        self.initializeWallMovement()
        self.initializeDoors()
        self.initializeDoorsMovement()
        self.initializeLabels()
        
    }
    
    func distanceBetween(point p1: CGPoint, andPoint p2:CGPoint) -> CGFloat {
        return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    func initializeDoors() {
        
        self.setDoorAttributes(position: "left")
        leftDoor.position = CGPoint(x: (view!.bounds.size.width / 2) - (25 * leftDoor.frame.size.width / 20), y: self.view!.bounds.size.height +
            leftDoor.frame.size.height / 2)
        leftDoor.zPosition = 0
        addChild(leftDoor)
        
        self.setDoorAttributes(position: "center")
        centerDoor.position = CGPoint(x: (view!.bounds.size.width / 2), y: self.view!.bounds.size.height + centerDoor.frame.size.height / 2)
        centerDoor.zPosition = 0
        addChild(centerDoor)
        
        self.setDoorAttributes(position: "right")
        rightDoor.position = CGPoint(x: (view!.bounds.size.width / 2) + (25 * rightDoor.frame.size.width / 20), y: self.view!.bounds.size.height +
            rightDoor.frame.size.height / 2)
        rightDoor.zPosition = 0
        addChild(rightDoor)
        
    }
    
    func initializeDoorsMovement() {
        
        let doorSpeed: CGFloat = 250.0
        var leftDoorAction: SKAction!
        var centerDoorAction: SKAction!
        var rightDoorAction: SKAction!
        
        self.enumerateChildNodes(withName: "*_door") {
            node, stop in
            
            //print("Node name \(node.name!)")
            
            let nextDoorPosition = CGPoint(x: node.position.x, y: -(self.wall.frame.size.height - node.frame.size.height / 2))
            let duration = self.distanceBetween(point: node.position, andPoint: nextDoorPosition) / doorSpeed
            let moveDoorAction = SKAction.moveTo(y: nextDoorPosition.y, duration: Double(duration))
            
            let resetPositionAction = SKAction.run {
                self.setDoorAttributes(position: node.name!)
                node.position = CGPoint(x: node.position.x, y: self.view!.bounds.size.height + node.frame.size.height / 2)
            }
            
            node.isHidden = false
            self.resetWave = true
            
            let delayAction = SKAction.wait(forDuration: 2.0)
            let sequence = SKAction.sequence([moveDoorAction, resetPositionAction, delayAction])
            
            switch node.name! {
            case "wrong_left_door", "correct_left_door":
                leftDoorAction = SKAction.repeatForever(sequence)
            case "wrong_center_door", "correct_center_door":
                centerDoorAction = SKAction.repeatForever(sequence)
            case "wrong_right_door", "correct_right_door":
                rightDoorAction = SKAction.repeatForever(sequence)
            default : break
            }
        }
        
        leftDoor.run(leftDoorAction)
        centerDoor.run(centerDoorAction)
        rightDoor.run(rightDoorAction)
        
    }
    
    func initializeLabels() {
        
        labelScore = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelScore.fontColor = UIColor.red
        labelScore.fontSize = 20
        labelScore.position = CGPoint(x: (3 * labelScore.fontSize), y: (view!.bounds.size.height - 2 * labelScore.fontSize))
        labelScore.zPosition = 3
        labelScore.text = "Score: \(score)"
        addChild(labelScore)
        
    }
    
    func initializeMainCharacter() {
        
        rabbit = SKSpriteNode(imageNamed: "rabbit")
        rabbit.position = CGPoint(x: (view!.bounds.size.width / 2), y: rabbit.size.height)
        rabbit.zPosition = 1
        
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
    
    func initializeWave() {
        
        if self.isCollisionDetected {
            self.isCollisionDetected = false
        } else {
            self.score += 10
            self.labelScore.text = "Score: \(score)"
        }
        
        self.resetWave = false
        
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
    
    func setDoorAttributes(position: String) {
        
        switch position {
        case "wrong_left_door", "correct_left_door", "left":
            if (arc4random_uniform(2) == 0) {
                if (leftDoor == nil) {
                    leftDoor = SKSpriteNode(imageNamed: "wrong_door")
                }
                leftDoor.texture = SKTexture(imageNamed: "wrong_door")
                leftDoor.name = "wrong_left_door"
            } else {
                if (leftDoor == nil) {
                    leftDoor = SKSpriteNode(imageNamed: "correct_door")
                }
                leftDoor.texture = SKTexture(imageNamed: "correct_door")
                leftDoor.name = "correct_left_door"
            }
        case "wrong_center_door", "correct_center_door", "center":
            if (arc4random_uniform(2) == 0) {
                if (centerDoor == nil) {
                    centerDoor = SKSpriteNode(imageNamed: "wrong_door")
                }
                centerDoor.texture = SKTexture(imageNamed: "wrong_door")
                centerDoor.name = "wrong_center_door"
            } else {
                if (centerDoor == nil) {
                    centerDoor = SKSpriteNode(imageNamed: "correct_door")
                }
                centerDoor.texture = SKTexture(imageNamed: "correct_door")
                centerDoor.name = "correct_center_door"
            }
        case "wrong_right_door", "correct_right_door", "right":
            if (arc4random_uniform(2) == 0) {
                if (rightDoor == nil) {
                    rightDoor = SKSpriteNode(imageNamed: "wrong_door")
                }
                rightDoor.texture = SKTexture(imageNamed: "wrong_door")
                rightDoor.name = "wrong_right_door"
            } else {
                if (rightDoor == nil) {
                    rightDoor = SKSpriteNode(imageNamed: "correct_door")
                }
                rightDoor.texture = SKTexture(imageNamed: "correct_door")
                rightDoor.name = "correct_right_door"
            }
        default: break
        }
        
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
        
        if !self.isCollisionDetected {
            self.detectCollisions()
        }
        
        if resetWave {
            self.initializeWave()
        }
        
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
