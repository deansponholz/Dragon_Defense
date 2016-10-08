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
        
        let backgroundImageNode = SKSpriteNode(imageNamed: "graph_paper_background")
        backgroundImageNode.size = CGSizeMake(self.frame.size.width, self.frame.size.height)
        backgroundImageNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        backgroundImageNode.name = "background"
        backgroundImageNode.zPosition = 0
        self.addChild(backgroundImageNode)
        
        let dragonImageMifsud = SKSpriteNode.init(imageNamed: "mifsudDragon")
        dragonImageMifsud.zPosition = 1
        dragonImageMifsud.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.7)
        self.addChild(dragonImageMifsud)
        
        let instructionNode = SKSpriteNode(imageNamed: "game_instruction")
        instructionNode.position = CGPointMake(self.frame.size.width * 0.4, self.frame.size.height * 0.4)
        instructionNode.zPosition = 1
        instructionNode.name = "instructionNode"
        instructionNode.xScale = 0.9
        self.addChild(instructionNode)
        
        let startNode = SKSpriteNode(imageNamed: "game_new")
        startNode.position = CGPointMake(self.frame.size.width * 0.375, self.frame.size.height * 0.275)
        startNode.zPosition = 1
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