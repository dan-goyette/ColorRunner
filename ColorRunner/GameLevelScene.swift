//
//  GameScene.swift
//  Junk
//
//  Created by Dan on 7/7/15.
//  Copyright (c) 2015 Dan. All rights reserved.
//

import SpriteKit

class GameLevelScene: SKScene {
    
    var didInit = false

 
  
    var gameWorldWrapper: SKSpriteNode!
    var gameWorldContainer: SKSpriteNode!
    var playerRectangle: SKSpriteNode!
    var playerPhysics: SKPhysicsBody!
    var playerIsMoving: Bool!
    var moveButton: SKShapeNode!
    
    func tryDoInit() {
        if (!self.didInit) {
            
            
            
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
            }
            
            
            self.playerRectangle = SKSpriteNode()
            self.playerRectangle.size = CGSize(width: 20, height: 44)
            self.playerRectangle.color = UIColor.redColor()
            self.playerRectangle.position = CGPointMake( 140, 644)
            self.playerRectangle.anchorPoint = CGPointMake(0.0 , 0.0)
            self.gameWorldContainer.addChild(self.playerRectangle)
            
            self.playerPhysics = SpriteFactory.CreateDefaultPhysicsBody(self.playerRectangle!)
            self.playerRectangle.physicsBody  = self.playerPhysics
            
            let eye = SKSpriteNode()
            eye.size = CGSize(width: 14, height: 4)
            eye.color = UIColor.blackColor()
            eye.position = CGPointMake( 16, 35)
            eye.anchorPoint = CGPointMake(0.0 , 0.0)
            self.playerRectangle.addChild(eye)

            self.playerIsMoving = false
            
            
            
            
            self.moveButton = SKShapeNode(circleOfRadius: 30)
            self.moveButton.fillColor = UIColor.redColor()
            self.moveButton.position = CGPointMake(-450, 0)
            self.moveButton.zPosition = 2
            self.addChild(self.moveButton)
            
            
            // Initialization is complete
            self.didInit = true;
        }
    }
    
   
    
    override func didMoveToView(view: SKView) {
        tryDoInit();
        view.showsPhysics = true    }
    
    var LevelName: String!
    var ContainerSprite: SKSpriteNode!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if(self.moveButton.containsPoint(location)) {
                self.playerIsMoving = true
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.playerIsMoving = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (self.playerIsMoving! ) {
            let rate = CGFloat(0.55);
            let relativeVelocity = CGVectorMake(200-self.playerPhysics.velocity.dx, 0);
            self.playerPhysics.velocity=CGVectorMake(self.playerPhysics.velocity.dx+relativeVelocity.dx*rate, self.playerPhysics.velocity.dy+relativeVelocity.dy*rate);
        }
        
        
    }
    
}
