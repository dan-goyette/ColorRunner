//
//  SpriteExtensions.swift
//  ColorRunner
//
//  Created by Dan on 7/14/15.
//  Copyright © 2015 Dan. All rights reserved.
//

import Foundation
import SpriteKit

class SpriteFactory {
    
    static func CreateDefaultPhysicsBody(spriteNode: SKSpriteNode) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size, center: CGPointMake(spriteNode.size.width / 2, spriteNode.size.height / 2))
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = false
        physicsBody.dynamic = true;
        return physicsBody
    }
}