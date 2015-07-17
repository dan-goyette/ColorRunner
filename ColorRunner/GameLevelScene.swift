//
//  GameScene.swift
//  Junk
//
//  Created by Dan on 7/7/15.
//  Copyright (c) 2015 Dan. All rights reserved.
//

import SpriteKit
import Darwin

class GameLevelScene: SKScene, SKPhysicsContactDelegate {
    
    var didInit = false

 
  
    var gameWorldWrapper: SKSpriteNode!
    var gameWorldContainer: SKSpriteNode!
    var playerRectangle: SKSpriteNode!
    var playerPhysics: SKPhysicsBody!
    var moveButton: SKShapeNode!
    
    var playerIsMoving: Bool!
    var playerIsFacingRight: Bool!
    var playerWasFacingRight: Bool!
    var playerGroundContactCounter: Int32!
    
    var debugLabel: SKLabelNode!
    
    func tryDoInit(view: SKView) {
        if (!self.didInit) {
            //view.showsPhysics = true
            self.physicsWorld.contactDelegate = self
            
            self.gameWorldWrapper = SKSpriteNode()
            self.gameWorldWrapper.size = CGSize(width: AppConstants.UILayout.PlayableAreaWidth + 2, height: AppConstants.UILayout.PlayableAreaHeight + 2)
            self.gameWorldWrapper.color = UIColor.purpleColor()
            self.gameWorldWrapper.position = CGPointMake( 0, 0)
            self.gameWorldWrapper.anchorPoint = CGPointMake(0.5 ,0.5)
            
            self.addChild(self.gameWorldWrapper)
            
            
            self.gameWorldContainer = SKSpriteNode()
            self.gameWorldContainer.size = CGSize(width: AppConstants.UILayout.PlayableAreaWidth, height: AppConstants.UILayout.PlayableAreaHeight)
            self.gameWorldContainer.color = UIColor.grayColor()
            self.gameWorldContainer.position = CGPoint( x: -1 * (AppConstants.UILayout.PlayableAreaWidth) / 2, y: -1 * (AppConstants.UILayout.PlayableAreaHeight) / 2)
            self.gameWorldContainer.anchorPoint = CGPointMake(0 ,0)
            
            self.gameWorldWrapper.addChild(self.gameWorldContainer)
            
       
            
            let floor = SKSpriteNode()
            floor.size = CGSize(width: AppConstants.UILayout.PlayableAreaWidth, height: 4)
            floor.color = UIColor.brownColor()
            floor.position = CGPointMake( 0, 140)
            floor.anchorPoint = CGPointMake(0.0 , 0.0)
            
            self.gameWorldContainer.addChild(floor)
            
            floor.physicsBody = SpriteFactory.CreateDefaultPhysicsBody(floor)
            if let floorPhysics = floor.physicsBody {
                floorPhysics.affectedByGravity = false
                floorPhysics.allowsRotation = false
                floorPhysics.dynamic = false;
                floorPhysics.categoryBitMask = groundCategory
                floorPhysics.contactTestBitMask = 0x0

            }
            
            let rotate45 = SKAction.rotateByAngle(CGFloat(M_PI / 4), duration: 0)
            
            let ramp1 = SKSpriteNode()
            ramp1.size = CGSize(width: 300, height: 4)
            ramp1.color = UIColor.brownColor()
            ramp1.position = CGPointMake( 500, 140)
            ramp1.anchorPoint = CGPointMake(0.0 , 0.0)
            ramp1.runAction(rotate45)
            self.gameWorldContainer.addChild(ramp1)
            
            ramp1.physicsBody = SpriteFactory.CreateDefaultPhysicsBody(ramp1)
            if let ramp1Physics = ramp1.physicsBody {
                ramp1Physics.affectedByGravity = false
                ramp1Physics.allowsRotation = false
                ramp1Physics.dynamic = false;
                ramp1Physics.categoryBitMask = groundCategory
                ramp1Physics.contactTestBitMask = 0x0

            }

            
            
            let ramp2 = SKSpriteNode()
            ramp2.size = CGSize(width: 400, height: 4)
            ramp2.color = UIColor.brownColor()
            ramp2.position = CGPointMake( 1000, 140)
            ramp2.anchorPoint = CGPointMake(0.0 , 0.0)
            ramp2.runAction(rotate45)
            self.gameWorldContainer.addChild(ramp2)
            
            ramp2.physicsBody = SpriteFactory.CreateDefaultPhysicsBody(ramp2)
            if let ramp2Physics = ramp2.physicsBody {
                ramp2Physics.affectedByGravity = false
                ramp2Physics.allowsRotation = false
                ramp2Physics.dynamic = false;
                ramp2Physics.categoryBitMask = groundCategory
                ramp2Physics.contactTestBitMask = 0x0
            }
            
            
            self.playerRectangle = SKSpriteNode()
            self.playerRectangle.size = CGSize(width: 20, height: 44)
            self.playerRectangle.color = UIColor.redColor()
            self.playerRectangle.position = CGPointMake( 140, 494)
            self.playerRectangle.anchorPoint = CGPointMake(0.0 , 0.0)
            self.gameWorldContainer.addChild(self.playerRectangle)
            
            self.playerPhysics = SpriteFactory.CreateDefaultPhysicsBody(self.playerRectangle!)
            self.playerRectangle.physicsBody  = self.playerPhysics
            self.playerPhysics.categoryBitMask = playerCategory
            self.playerPhysics.contactTestBitMask = groundCategory
            self.playerPhysics.collisionBitMask = groundCategory

            self.playerPhysics.usesPreciseCollisionDetection = true
            
            let eye = SKSpriteNode()
            eye.size = CGSize(width: 14, height: 4)
            eye.color = UIColor.blackColor()
            eye.position = CGPointMake( 16, 35)
            eye.anchorPoint = CGPointMake(0.0 , 0.0)
            self.playerRectangle.addChild(eye)

            self.playerIsMoving = false
            self.playerIsFacingRight = true;
            self.playerWasFacingRight = true;
            
            
            
            self.moveButton = SKShapeNode(circleOfRadius: 30)
            self.moveButton.fillColor = UIColor.redColor()
            self.moveButton.position = CGPointMake(-450, 0)
            self.moveButton.zPosition = 2
            self.addChild(self.moveButton)
            
            
            
            self.debugLabel = SKLabelNode()
            self.debugLabel.position = CGPointMake(-450, 300)
            self.debugLabel.text = "Debug"
            self.debugLabel.fontSize = 16
            self.addChild(debugLabel)
            
            self.playerGroundContactCounter = 0
            
            // Initialization is complete
            self.didInit = true;
        }
    }
    
   
    
    override func didMoveToView(view: SKView) {
        tryDoInit(view);
        
    }
    
    var LevelName: String!
    var ContainerSprite: SKSpriteNode!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        self.playerIsFacingRight = !self.playerIsFacingRight
        self.playerRectangle.xScale *= -1
        
        //for touch in touches {
        //            let location = touch.locationInNode(self)
        //
        //            if(self.moveButton.containsPoint(location)) {
        //                self.playerIsMoving = true
        //            }
        //}
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //self.playerIsMoving = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
       
        
        applyPlayerMovement()
        //tryRepositionGameWorldWrapper()
        
    }
    
    func applyPlayerMovement() {
        
        if (self.playerGroundContactCounter! > 0) {
            setDebugMessage("Touching")
            let maxSpeed = CGFloat(300)
            let currentSpeed = abs(self.playerPhysics.velocity.dx)
            var newSpeed = maxSpeed - currentSpeed
            if (newSpeed < 0) {
                newSpeed = 0
            }
            
            if (!self.playerIsFacingRight!) {
                newSpeed *= -1
            }
            
            self.playerPhysics.applyForce(CGVector(dx: newSpeed,dy: 0))
        } else {
            setDebugMessage("Not Touching")
        }

    
        //        if (self.playerIsMoving! ) {
//        let coeff = CGFloat(self.playerIsFacingRight! ? 1.0 : -1.0)
//        let rate = CGFloat(0.95);
//        
//        let relativeVelocity = CGVectorMake(300-abs(self.playerPhysics.velocity.dx), 0);
//        self.playerPhysics.velocity=CGVectorMake(self.playerPhysics.velocity.dx+relativeVelocity.dx * rate * coeff, self.playerPhysics.velocity.dy+relativeVelocity.dy * rate);
        //        }
        
    }
    
    func tryRepositionGameWorldWrapper() {
//        gameWorldWrapper.position.x++;
        
        
        let playerPoint = convertPoint(self.playerRectangle.position, fromNode: self.gameWorldWrapper)
        let playerPointX = convertPoint(playerPoint, fromNode: self)
        let playerPointY = convertPoint(playerPointX, fromNode: self)
        
        setDebugMessage(String(playerPointY.x))
        
        let diff = playerPointY.x - UIScreen.mainScreen().bounds.width / 2
       
        
        
        
        var action : SKAction? = nil
        var duration: NSTimeInterval = 0
        
        if ((self.playerIsFacingRight! && !self.playerWasFacingRight!)
            || (!self.playerIsFacingRight! && self.playerWasFacingRight!)) {
            duration = 0//0.25
            self.playerWasFacingRight = !self.playerWasFacingRight!
        }

        if (diff > -150 && self.playerIsFacingRight!) {
            //gameWorldWrapper.position.x -= diff + 100
            
            action = SKAction.moveByX(-1 * (diff + 150), y: 0, duration: duration)
        } else if (diff < 350 && !self.playerIsFacingRight!) {
           // gameWorldWrapper.position.x -= diff - 100
            
            action = SKAction.moveByX(-1 * (diff - 350), y: 0, duration: duration)
        }
        if (action != nil) {
            gameWorldWrapper.runAction(action!)
        }
    }
    
    
    let groundCategory:UInt32 = 0x1 << 0
    let playerCategory:UInt32 = 0x1 << 1
    
    
    func setDebugMessage(message: String) {
        self.debugLabel.text = message
    }
    
    
    func didBeginContact(contact: SKPhysicsContact )
    {
        let collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    
        if (collision == (groundCategory | playerCategory)) {
            self.playerGroundContactCounter!++
        }
    }
    
    func didEndContact(contact : SKPhysicsContact )
    {
        let collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
   
        if (collision == (groundCategory | playerCategory)) {
            self.playerGroundContactCounter!--
            
        }
    }
    
}
