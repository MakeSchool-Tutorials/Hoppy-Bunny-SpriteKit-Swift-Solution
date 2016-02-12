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
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Recurisve node search for 'hero' */
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* Apply vertical impulse */
        hero.physicsBody?.applyImpulse(CGVectorMake(0, 400))
        
        /* Apply subtle rotation */
        hero.physicsBody?.applyAngularImpulse(1)

        sinceTouch = 0
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        
        /* Restrict vertical velocity */
        if(velocityY > 400) {
            hero.physicsBody?.velocity.dy = 400
        }
        
        /* Apply falling rotation */
        if (sinceTouch > 0.1) {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        
        /* Clamp rotation */
        hero.zRotation.clamp(CGFloat(-90).degreesToRadians(),CGFloat(30).degreesToRadians())
        hero.physicsBody?.angularVelocity.clamp(-2, 2)
        
        sinceTouch+=fixedDelta
    }

}


