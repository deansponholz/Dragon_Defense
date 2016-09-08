//
//  redDragon.swift
//  Shooter
//
//  Created by Dean on 8/24/16.
//  Copyright © 2016 Dean Sponholz. All rights reserved.
//

import Foundation
import SpriteKit

class redDragon: SKSpriteNode {
    
    let None: UInt32 = 0
    let bulletCategory: UInt32 = 0x1 << 0
    let dragonCategory: UInt32 = 0x1 << 1
    let dragonProjectileCategory: UInt32 = 0x1 << 2
    let turretCategory: UInt32 = 0x1 << 3
    
    var atlas = SKTextureAtlas()
    var dragonFlyFrames : [SKTexture]!
    
    init() {
        
        
        let dragonAnimatedAtlas = SKTextureAtlas(named: "redDragonSprites")
        
        var flyFrames = [SKTexture]()
        let numImages = dragonAnimatedAtlas.textureNames.count
        
        for var i=1; i<=numImages; i++ {
            let dragonTextureName = "redDragon\(i)"
            flyFrames.append(dragonAnimatedAtlas.textureNamed(dragonTextureName))
        }
        
        dragonFlyFrames = flyFrames
        let firstFrame = dragonFlyFrames[0]
        super.init(texture: firstFrame, color: SKColor.clearColor(), size: firstFrame.size())
        self.name = "redDragon"
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.zPosition = 2
        self.position = loadRandSpawnLeft()

        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSizeMake(self.size.width, self.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = dragonCategory
        self.physicsBody?.collisionBitMask = bulletCategory
        self.physicsBody?.contactTestBitMask = bulletCategory
        //loadAppearance_DragonProjectile()
        //dragonLoadAppearance_healthbar()
        //dragonFlyAnimation()
        //dragonMoveRight()
        addChild(self)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func dragonFlyAnimation(){
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(dragonFlyFrames, timePerFrame: 0.125)))
    }
    
    func loadRandSpawnLeft() -> CGPoint{
        var MinSpawnValue = self.frame.size.height * 0.325
        var MaxSpawnValue = self.frame.size.height * 0.8
        var SpawnPosition = UInt32(MaxSpawnValue - MinSpawnValue)
        return CGPointMake(self.frame.size.width * 0.0075, CGFloat(arc4random_uniform(SpawnPosition)) + MinSpawnValue)
    }
    func loadRandDestinationRight() -> CGPoint{
        var MinSpawnValue = self.frame.size.height * 0.365
        var MaxSpawnValue = self.frame.size.height * 0.8
        var SpawnPosition = UInt32(MaxSpawnValue - MinSpawnValue)
        return CGPointMake(self.frame.size.width, CGFloat(arc4random_uniform(SpawnPosition)) + MinSpawnValue)
    }
    
}