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
            
            self.playerRectangle = SKSpriteNode()
            self.playerRectangle.size = CGSize(width: 20, height: 45)
            self.playerRectangle.color = UIColor.redColor()
            self.playerRectangle.position = CGPointMake( 140, 144)
            self.playerRectangle.anchorPoint = CGPointMake(0.0 , 0.0)
            self.gameWorldContainer.addChild(self.playerRectangle)
            
            let eye = SKSpriteNode()
            eye.size = CGSize(width: 4, height: 4)
            eye.color = UIColor.blackColor()
            eye.position = CGPointMake( 16, 35)
            eye.anchorPoint = CGPointMake(0.0 , 0.0)
            self.playerRectangle.addChild(eye)

            
            // Initialization is complete
            self.didInit = true;
        }
    }
    
    override func didMoveToView(view: SKView) {
        tryDoInit();
        
        
        let tlLabel = SKLabelNode(fontNamed:"Arial")
        tlLabel.text = "TL";
        tlLabel.fontSize = 65;
        tlLabel.color = UIColor.whiteColor()
        tlLabel.position = CGPoint(x:0, y:0);
        tlLabel.horizontalAlignmentMode = .Left

        self.gameWorldContainer.addChild(tlLabel);
        

    }
    
    var LevelName: String!
    var ContainerSprite: SKSpriteNode!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        //        for touch in touches {
        //            let location = touch.locationInNode(self)
        //
        //        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        self.playerRectangle.position.x += 4
    }
}
