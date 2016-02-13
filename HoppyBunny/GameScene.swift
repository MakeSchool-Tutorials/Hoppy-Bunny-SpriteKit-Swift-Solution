//
//  GameScene.swift
//  HoppyBunny
//
//  Created by Martin Walsh on 08/02/2016.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var hero: SKSpriteNode!
    var sinceTouch: CFTimeInterval = 0
    var scrollNode: SKNode!
    
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 100
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Recursive node search for 'hero' as referenced */
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        
        /* Set reference to scroll node */
        scrollNode = self.childNodeWithName("scrollNode")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* Apply vertical impulse */
        hero.physicsBody?.applyImpulse(CGVectorMake(0, 400))
        
        /* Apply subtle rotation */
        hero.physicsBody?.applyAngularImpulse(1)

        /* Reset touch timer */
        sinceTouch = 0
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        /* Grab current velocity */
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        
        /* Check and cap vertical velocity */
        if velocityY > 400 {
            hero.physicsBody?.velocity.dy = 400
        }
        
        /* Apply falling rotation */
        if sinceTouch > 0.1 {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }

        /* Clamp rotation */
        hero.zRotation.clamp(CGFloat(-90).degreesToRadians(),CGFloat(30).degreesToRadians())
        hero.physicsBody?.angularVelocity.clamp(-2, 2)
    
        /* Process world scrolling */
        scrollWorld()
        
        /* Update last touch timer */
        sinceTouch+=fixedDelta
    }
    
    func scrollWorld() {
        /* Scroll World */
        
        scrollNode.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll node sprites */
        for node in scrollNode.children as! [SKSpriteNode] {
            
            /* Ground node position, convert node position to scene space */
            let nodePosition = scrollNode.convertPoint(node.position, toNode: self)
            
            /* Check if ground sprite has left the scene */
            if nodePosition.x <= -node.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPointMake( (self.size.width / 2) + node.size.width, nodePosition.y)
                
                /* Convert new node position back to scroll node space */
                node.position = self.convertPoint(newPosition, toNode: scrollNode)
            }
        }
    }
}


