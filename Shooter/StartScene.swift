//
//  StartScene.swift
//  Shooter
//
//  Created by Dean Sponholz on 6/11/16.
//  Copyright © 2016 Dean Sponholz. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: SKScene {

    override func didMoveToView(view: SKView) {
        
        
        //backgroundColor = SKColor.init(red: 113.0/255.0, green: 113.0/255.0, blue: 198.0/255.0, alpha: 1.0)
        
        backgroundColor = SKColor.whiteColor()
        let dragonImageMifsud = SKSpriteNode.init(imageNamed: "mifsudDragon")
        dragonImageMifsud.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        
        self.addChild(dragonImageMifsud)
        
        
        let startNode = SKSpriteNode(imageNamed: "gameStart")
        startNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.25)
        startNode.name = "startNode"
        startNode.xScale = 0.9
        self.addChild(startNode)
    
}
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject! in touches {
            
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            if let name = touchedNode.name{
                if name == "startNode"{
                    let myScene = GameScene(size: CGSize(width: 1536, height: 2048))
                    myScene.scaleMode = .Fill
                    let reveal = SKTransition.fadeWithDuration(0.75)
                    self.view?.presentScene(myScene, transition: reveal)
                }
                
            }
        }
        
    }

    
}