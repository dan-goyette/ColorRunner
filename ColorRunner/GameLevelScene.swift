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
  
    var gameWorldContainer: SKSpriteNode!
    var playerRectangle: SKSpriteNode!
    var playerPhysics: SKPhysicsBody!
    var moveButton: SKShapeNode!
    var desiredCameraPosition: CGPoint!
    
    var playerIsMoving: Bool!
    var playerIsFacingRight: Bool!
    var playerWasFacingRight: Bool!
    var playerGroundContactCounter: Int32!
 
    var lastDragPosition: CGPoint?
    
    var maxX: CGFloat!
    var minX: CGFloat!
    
    var maxY: CGFloat!
    var minY: CGFloat!
    
    let playerVerticalBoundsLimit: CGFloat = 0.35
    var isPerformingHorizontalPlayerPositionCorrection: Bool = false

    
    var debugLabel: SKLabelNode!
    
    func tryDoInit(view: SKView) {
        if (!self.didInit) {
            view.showsPhysics = true
            self.physicsWorld.contactDelegate = self
            self.desiredCameraPosition = CGPointMake(0,0)
            self.lastDragPosition = nil
            
            
            self.gameWorldContainer = SKSpriteNode()
            self.gameWorldContainer.size = CGSize(width: AppConstants.UILayout.PlayableAreaWidth, height: AppConstants.UILayout.PlayableAreaHeight)
            self.gameWorldContainer.color = UIColor.grayColor()
//            self.gameWorldContainer.position = CGPoint( x: -1 * (AppConstants.UILayout.PlayableAreaWidth) / 2, y: -1 * (AppConstants.UILayout.PlayableAreaHeight) / 2)
            self.gameWorldContainer.position = CGPoint( x: 3000, y: 3000)
            self.addChild(self.gameWorldContainer)
            
            
            self.maxX = self.gameWorldContainer.size.width / 2
            self.minX = self.size.width - self.gameWorldContainer.size.width / 2

            self.maxY = self.gameWorldContainer.size.height / 2
            self.minY = self.size.height - self.gameWorldContainer.size.height / 2
            

            
            
            let tlBox = SKSpriteNode()
            tlBox.size = CGSize(width: 10, height: 10)
            tlBox.color = UIColor.redColor()
            tlBox.position = getTranslatedPositionWithinGameContainer(5,y: 5)
            self.gameWorldContainer.addChild(tlBox)
       
            
            let floor = SKSpriteNode()
            floor.size = CGSize(width: AppConstants.UILayout.PlayableAreaWidth, height: 4)
            floor.color = UIColor.brownColor()
            floor.position = getTranslatedPositionWithinGameContainer(0,y: 140)
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
            ramp1.position = getTranslatedPositionWithinGameContainer(500,y: 140)
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
            ramp2.size = CGSize(width: 1000, height: 4)
            ramp2.color = UIColor.brownColor()
            ramp2.position = getTranslatedPositionWithinGameContainer(1000,y: 140)
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
            self.playerRectangle.position = getTranslatedPositionWithinGameContainer(140 ,y: 500)
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
            self.moveButton.position = CGPointMake(50, 400)
            self.moveButton.zPosition = 2
            self.addChild(self.moveButton)
            
            
            
            self.debugLabel = SKLabelNode()
            self.debugLabel.position = CGPointMake(100, 100)
            self.debugLabel.text = "Debug"
            self.debugLabel.fontSize = 16
            self.addChild(debugLabel)
            
            self.playerGroundContactCounter = 0
            
            // Initialization is complete
            self.didInit = true;
            
            let junk = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(1, 1))
            junk.position = CGPointMake(0,0)
            self.addChild(junk)
            
            ensureGameWorldContainerIsInScene()
        }
    }
    
    func getTranslatedPositionWithinGameContainer( desiredCoordinates: CGPoint) -> CGPoint {
        return getTranslatedPositionWithinGameContainer(desiredCoordinates.x, y: desiredCoordinates.y)
    }
    func getTranslatedPositionWithinGameContainer( x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPointMake(x - CGFloat(AppConstants.UILayout.PlayableAreaWidth / 2), y - CGFloat(AppConstants.UILayout.PlayableAreaHeight / 2))
    }
    
    func ensureGameWorldContainerIsInScene() {
        if (self.gameWorldContainer.position.x < self.minX) {
            self.gameWorldContainer.position.x = self.minX
        }
        if (self.gameWorldContainer.position.x > self.maxX) {
            self.gameWorldContainer.position.x = self.maxX
        }
        
        if (self.gameWorldContainer.position.y < self.minY) {
            self.gameWorldContainer.position.y = self.minY
        }
        if (self.gameWorldContainer.position.y > self.maxY) {
            self.gameWorldContainer.position.y = self.maxY
        }
    }
    
    override func didMoveToView(view: SKView) {
        tryDoInit(view);
        
    }
    
    var LevelName: String!
    var ContainerSprite: SKSpriteNode!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        for touch in touches {
            let location = touch.locationInNode(self)
            self.lastDragPosition = location
        
            if(self.moveButton.containsPoint(location)) {
                self.playerIsFacingRight = !self.playerIsFacingRight
                self.playerRectangle.xScale *= -1
                self.playerIsMoving = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let deltaX = location.x - self.lastDragPosition!.x
            let deltaY = location.y - self.lastDragPosition!.y
            self.gameWorldContainer.position.x += deltaX
            self.gameWorldContainer.position.y += deltaY
            self.lastDragPosition = location
            
            ensureGameWorldContainerIsInScene()
            
            //
//            // Ensure the container never goes out of the scene bounds. 
//            if (containerPositionInScene.x > 0) {
//                
//                self.gameWorldContainer.position.x = convertPoint(CGPointMake(0,0), toNode: self.gameWorldContainer).x
//            }
            
            setDebugMessage(String(self.gameWorldContainer.position))
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.playerIsMoving = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
       
        
        applyPlayerMovement()
        tryRepositionGameWorld()
         //self.gameWorldContainer.position.x++
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
    
    func tryRepositionGameWorld() {
        
        
   
        let playerPositionInWorldContainer = convertPoint(self.playerRectangle.position, fromNode: self.gameWorldContainer)
        let playerPointInScene = convertPoint(playerPositionInWorldContainer, fromNode: self)
        
        

        // Handle player vertical position. It doesn't matter where the player is facing. If they go beyond the upper/lower
        // 25% of the screen, we scroll the up/down accordingly to keep the player inside the middle 50% of the vertical screen
        
        let playerVerticalPositionPercentageInGameWorldContainer = playerPositionInWorldContainer.y / UIScreen.mainScreen().bounds.height
        
        //setDebugMessage(String(Int(playerPositionInWorldContainer.x)) + ", " + String(Int(playerPositionInWorldContainer.y)) + " (" + String(Int(100 * playerVerticalPositionPercentageInGameWorldContainer)) + "%)")
        
        if (playerVerticalPositionPercentageInGameWorldContainer > (1.0 - playerVerticalBoundsLimit)) {
            self.gameWorldContainer.position.y -=  ( playerVerticalPositionPercentageInGameWorldContainer - (1.0 - playerVerticalBoundsLimit)) * UIScreen.mainScreen().bounds.height
        } else if (playerVerticalPositionPercentageInGameWorldContainer < playerVerticalBoundsLimit) {
            self.gameWorldContainer.position.y -=  ( playerVerticalPositionPercentageInGameWorldContainer - playerVerticalBoundsLimit) * UIScreen.mainScreen().bounds.height
        }
        
        
        
        // Horizontal position is more complex, as it depends on which direction the player is facing.
        // In general, if the player isfacing in a direction, and less than 75% of the screen is ahead of them,
        // reposition the container so that 75% is visible. Do this with instantaneous motion changes.
        // However, if the player changes horizontal directions, this will result in a substantial change,
        // which we would much rather animate in order to make is smooth. So, more precisely, if the player is close to 
        // the 75% mark, make the instantaneous change. Otherwise animate a large change. While animating, don't handle any
        // other changes.
        
        
        if (!self.isPerformingHorizontalPlayerPositionCorrection) {
            let playerHorizontalPositionPercentageInGameWorldContainer = playerPositionInWorldContainer.x / UIScreen.mainScreen().bounds.width
            var requiredPercentDelta : CGFloat = 0.00
            
            if (playerIsFacingRight!) {
                // Player is facing right, so adjust if the player is further than 25% of the way across the screen
                if (playerHorizontalPositionPercentageInGameWorldContainer > playerVerticalBoundsLimit) {
                    requiredPercentDelta = playerVerticalBoundsLimit - playerHorizontalPositionPercentageInGameWorldContainer
                }
                
            } else {
                if (playerHorizontalPositionPercentageInGameWorldContainer < (1.0 - playerVerticalBoundsLimit)) {
                    requiredPercentDelta = (1.0 - playerVerticalBoundsLimit) - playerHorizontalPositionPercentageInGameWorldContainer
                }
            }
            
            setDebugMessage(String(Int(playerPositionInWorldContainer.x)) + " (" + String(Int(100 * playerHorizontalPositionPercentageInGameWorldContainer)) + "%)")
            
            
            if (requiredPercentDelta != 0) {
                
                if (abs(requiredPercentDelta) < 0.05) {
                    // Small change. Change position instantaneously,
                    self.gameWorldContainer.position.x += requiredPercentDelta * UIScreen.mainScreen().bounds.width
                } else {
                    // Large change. Animate for smoothness, blocking further changes until the animation finishes.
                    self.isPerformingHorizontalPlayerPositionCorrection = true
                    let action = SKAction.moveByX(requiredPercentDelta * UIScreen.mainScreen().bounds.width, y: 0, duration: 0.25)
                    self.gameWorldContainer.runAction(action, completion: {self.isPerformingHorizontalPlayerPositionCorrection = false })
                }
            }
            
            
        }
        
        
        
        return
        
        
        let newX = playerPointInScene.x - UIScreen.mainScreen().bounds.width / 2
        let newY = playerPointInScene.y - UIScreen.mainScreen().bounds.height / 2
       
        desiredCameraPosition = CGPointMake( newX,  newY)
        
        // Get closer to the target point. How quickly we move towards it depends on the distance from it. 
        let percentChange = CGFloat(0.5)
        
        
        
        let distanceBetween = getDistanceSquared(desiredCameraPosition, p2: gameWorldContainer.position)
        
        // Special case: If we're very close, move the entire distance
        if (distanceBetween < 10) {
            gameWorldContainer.position = desiredCameraPosition
        } else {
            let xChange = abs(gameWorldContainer.position.x - desiredCameraPosition.x) * percentChange
            let yChange = abs(gameWorldContainer.position.y - desiredCameraPosition.y) * percentChange
            
            if (gameWorldContainer.position.x >= desiredCameraPosition.x) {
                gameWorldContainer.position.x = desiredCameraPosition.x + xChange
            } else {
                gameWorldContainer.position.x = desiredCameraPosition.x - xChange
            }
            
            if (gameWorldContainer.position.y >= desiredCameraPosition.y) {
                gameWorldContainer.position.y = desiredCameraPosition.y + yChange
            } else {
                gameWorldContainer.position.y = desiredCameraPosition.y - yChange
            }
        }
        
//        var action : SKAction? = nil
//        var duration: NSTimeInterval = 0
//        
//        if ((self.playerIsFacingRight! && !self.playerWasFacingRight!)
//            || (!self.playerIsFacingRight! && self.playerWasFacingRight!)) {
//            duration = 0//0.25
//            self.playerWasFacingRight = !self.playerWasFacingRight!
//        }
//
//        if (xDiff > -150 && self.playerIsFacingRight!) {
//            //gameWorldWrapper.position.x -= diff + 100
//            
//            action = SKAction.moveByX(-1 * (xDiff + 150), y: 0, duration: duration)
//        } else if (xDiff < 350 && !self.playerIsFacingRight!) {
//           // gameWorldWrapper.position.x -= diff - 100
//            
//            action = SKAction.moveByX(-1 * (xDiff - 350), y: 0, duration: duration)
//        }
//        if (action != nil) {
//            gameWorldWrapper.runAction(action!)
//        }
    }
    
    func getDistanceSquared(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2);
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
