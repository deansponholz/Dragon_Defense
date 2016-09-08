//
//  GameScene.swift
//  Shooter
//
//bean edits
//add shoot down egg, shoot power up drops






//  Created by Dean Sponholz on 6/11/16.
//  Copyright (c) 2016 Dean Sponholz. All rights reserved.
//http://www.theappguruz.com/blog/how-to-make-a-2d-game-background-in-photoshop
//https://www.quora.com/How-would-I-use-SpriteKit-to-make-a-health-and-stamina-bar-in-swift

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    //SpriteNodes
    
        //scene
    var backgroundImageNode = SKSpriteNode()
    var groundDirt = SKSpriteNode()
    var groundGrass = SKSpriteNode()
    
        //label
    var mainMenuLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var eggLabelNode = SKSpriteNode()
    var eggLabelScoreNode = SKLabelNode()
    
    var score: Int = 0
    var eggScore:Int = 0
    
    var destinationPoint = CGPoint()
    var dragonFlightSpeed: Double = 6.0
    var projectileFlightSpeed: Double = 4.0
        //interactive
    var bulletNode = SKSpriteNode()
    var scopeNode = SKSpriteNode()
    var turretNode = SKSpriteNode()
    
    
    var dragonNode = SKSpriteNode()
    var atlas = SKTextureAtlas()
    var dragonFlyFrames : [SKTexture]!
    var eggFlyFrames : [SKTexture]!
    var dragonProjectileNode = SKSpriteNode()
    var healthbar = SKSpriteNode()
    var healthbarFrame = SKSpriteNode()
    var healthRatio = Int()
    
    //var shootTimer = NSTimer()
    var collisionHappenedDragon_Bullet = Bool()
    var collisionHappenedProjectile_Turret = Bool()
    var collisionHappenedProjectile_Bullet = Bool()
    var vx = CGFloat()
    var vy = CGFloat()
    
    var touching = Bool()
    var positionInScene = CGPoint()
    var scopeColor = UIColor()
    var clearColor = UIColor()
    var shootLocationX = CGFloat()
    var shootDelayTime = Double()
    //var scopeCurrentColor = UIColor()
    
    let None: UInt32 = 0
    let bulletCategory: UInt32 = 0x1 << 0
    let dragonCategory: UInt32 = 0x1 << 1
    let dragonProjectileCategory: UInt32 = 0x1 << 2
    let turretCategory: UInt32 = 0x1 << 3
    //let eggCategory: UInt32 = 0x1 << 4
    
    var sceneBody = SKPhysicsBody()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        createScene()
    }
    
    func createScene(){
        
        //backgroundColor = UIColor.blackColor()
        
        loadAppearance_Background()
        loadAppearance_Bullet()
        loadAppearance_EggScoreLabel()
        loadAppearance_ScoreLabel()
        loadAppearance_MainMenuLabel()
        loadAppearance_Turret()
        castleLoadAppearance_healthbar()
        loadAppearance_Dragon()
        loadAppearance_DragonProjectile()
        addPhysicsWorld()
        startGame()
        
    }
    
    func startGame(){
        dragonFlyAnimation()
        dragonMoveRight()
        eggMoveRight()
        shootProjectile()
        //spawnEnemies()
        arrayDragons()
        
        
    }
    
    func resetDragon(){
        dragonProjectileNode.removeFromParent()
        dragonNode.removeFromParent()
        
        self.addChild(dragonNode)
        self.addChild(dragonProjectileNode)
        let point = loadRandSpawnLeft()
        dragonNode.runAction(SKAction.moveTo(point, duration: 0.0))
        dragonProjectileNode.runAction(SKAction.moveTo(point, duration: 0.0))
        
        dragonMoveRight()
        eggMoveRight()
        shootProjectile()
        
    }
    
    func arrayDragons(){
        var arraySprites :[SKSpriteNode] = [SKSpriteNode]()
        
        for i in 0 ..< 60 {
            let name = "dragonSprite \(i)"
            let dragonSprite : SKSpriteNode!
            let dragonAnimatedAtlas = SKTextureAtlas(named: "redDragonSprites")
            var flyFrames = [SKTexture]()
            let numImages = dragonAnimatedAtlas.textureNames.count
            for var i=1; i<=numImages; i++ {
                let dragonTextureName = "redDragon\(i)"
                flyFrames.append(dragonAnimatedAtlas.textureNamed(dragonTextureName))
            }

            dragonFlyFrames = flyFrames
            let firstFrame = dragonFlyFrames[0]
            dragonSprite = SKSpriteNode(texture: firstFrame)
            dragonSprite.name = name
            dragonSprite.anchorPoint = CGPointMake(0.5, 0.5)
            //dragonNode.setScale(0.225)
            dragonSprite.zPosition = 2
            dragonSprite.position = loadRandSpawnLeft()
            dragonSprite.name = "redDragon"
            dragonSprite.physicsBody = SKPhysicsBody(texture: dragonNode.texture!, size: CGSizeMake(dragonNode.size.width, dragonNode.size.height))
            dragonSprite.physicsBody?.affectedByGravity = false
            dragonSprite.physicsBody?.dynamic = false
            dragonSprite.physicsBody?.categoryBitMask = dragonCategory
            dragonSprite.physicsBody?.collisionBitMask = bulletCategory
            dragonSprite.physicsBody?.contactTestBitMask = bulletCategory
            
            arraySprites.append(dragonSprite)
            
            let action = SKAction.waitForDuration(1)
            let action1 = SKAction.a
            
        }
        for SKSpriteNode in arraySprites{
            let spawnEnemy = SKAction.sequence([SKAction.runBlock(
                {
                    [unowned self] in
                    self.addChild(SKSpriteNode)
                }),SKAction.waitForDuration(1)]);
            self.addChild(SKSpriteNode)
            SKSpriteNode.runAction(spawnEnemy)
        }
        
        
    }
    
    func spawnEnemies(){
        let spawnEnemy = SKAction.sequence([SKAction.runBlock(
            {
                [unowned self] in
                self.loadAppearance_Dragon();
            }),SKAction.waitForDuration(1)]);
    }
    
    func loadAppearance_Background(){
        backgroundImageNode = SKSpriteNode(imageNamed: "graph")
        self.name = "self"
        backgroundImageNode.size = CGSizeMake(self.frame.size.width, self.frame.size.height)
        backgroundImageNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        backgroundImageNode.name = "background"
        backgroundImageNode.zPosition = 0
        self.addChild(backgroundImageNode)
    }
    
    func loadAppearance_MainMenuLabel(){
        //ReloadLabel
        mainMenuLabel = SKLabelNode(fontNamed:"Chalkduster")
        mainMenuLabel.text = "Menu"
        //mainMenuLabel.fontColor = UIColor.blackColor()
        mainMenuLabel.fontSize = 80
        mainMenuLabel.position = CGPointMake(self.frame.size.width * 0.15, self.frame.size.height * 0.95)
        mainMenuLabel.name = "MainMenu"
        mainMenuLabel.fontColor = UIColor.blackColor()
        mainMenuLabel.zPosition = 1
        self.addChild(mainMenuLabel)
    }
    
    func loadAppearance_ScoreLabel(){
        //ReloadLabel
        scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreLabel.text = "0"
        //mainMenuLabel.fontColor = UIColor.blackColor()
        scoreLabel.fontSize = 80
        scoreLabel.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.95)
        //scoreLabel.name = "MainMenu"
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
    }
    
    func loadAppearance_EggScoreLabel(){
        //eggLabel
        eggLabelNode = SKSpriteNode(imageNamed: "EggLabel")
        eggLabelNode.setScale(0.50)
        eggLabelNode.position = CGPointMake(self.frame.size.width * 0.085, self.frame.size.height * 0.1)
        eggLabelNode.zPosition = 1
        self.addChild(eggLabelNode)
        //eggScoreLabel
        eggLabelScoreNode = SKLabelNode(fontNamed: "Chalkduster")
        eggLabelScoreNode.text = "0"
        eggLabelScoreNode.fontSize = 80
        eggLabelScoreNode.position = CGPointMake(self.frame.size.width * 0.085, self.frame.size.height * 0.025)
        eggLabelScoreNode.fontColor = UIColor.blackColor()
        eggLabelScoreNode.zPosition = 1
        self.addChild(eggLabelScoreNode)
        
    }
    
    func loadAppearance_Bullet(){
        //objectShotNode
        bulletNode = SKSpriteNode(imageNamed: "bullet")
        let texture = SKTexture(imageNamed: "bullet")
        bulletNode.setScale(3.0)
        
        bulletNode.anchorPoint = CGPointMake(0.5, 0.5)
        bulletNode.position = CGPointMake(self.frame.size.width * 0.5085, self.frame.size.height * 0.20)
        bulletNode.zPosition = 2
     
 
        bulletNode.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        bulletNode.physicsBody?.affectedByGravity = false
        bulletNode.physicsBody?.dynamic = true
        bulletNode.physicsBody?.categoryBitMask = bulletCategory
        bulletNode.physicsBody?.collisionBitMask = dragonCategory
        bulletNode.physicsBody?.contactTestBitMask = dragonCategory
        bulletNode.physicsBody?.contactTestBitMask = dragonProjectileCategory


        self.addChild(bulletNode)
        
    }
    
    func resetBullet(){
        
            //let resetBulletAction = SKAction.moveTo(CGPointMake(self.frame.size.width * 0.5385, self.frame.size.height * 0.175), duration: 0.0)
            bulletNode.removeFromParent()
            loadAppearance_Bullet()
        
           // bulletNode.runAction(resetBulletAction)
            bulletNode.zRotation = 0
            view?.userInteractionEnabled = true
    }
    
    func loadAppearance_Scope(){
        //scopeNode
        scopeNode = SKSpriteNode(imageNamed: "scope")
        scopeNode.anchorPoint = CGPointMake(0.5, 0.5)
        scopeNode.zPosition = 4
        //scopeNode.hidden = true
        //colorizeScope(scopeNode)
        self.addChild(scopeNode)
    }
    
    func colorizeScope(scopeNode: SKSpriteNode){
        let fadeOutAction = SKAction.fadeOutWithDuration(0.425)
        let hideAction = SKAction.hide()
        let actionSequence = SKAction.sequence([fadeOutAction, hideAction])
        scopeNode.runAction(actionSequence)
    }
    
    
    
    func loadAppearance_Turret(){
        //turretNode
        turretNode = SKSpriteNode(imageNamed: "turret")
        turretNode.anchorPoint = CGPointMake(0.5, 0.5)
        turretNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.09)
        turretNode.zPosition = 3
        turretNode.physicsBody = SKPhysicsBody(texture: turretNode.texture!, size: CGSizeMake(turretNode.size.width, turretNode.size.height))
        turretNode.physicsBody?.affectedByGravity = false
        turretNode.physicsBody?.dynamic = false
        turretNode.physicsBody?.categoryBitMask = turretCategory
        turretNode.physicsBody?.restitution = 0
        //turretNode.physicsBody?.collisionBitMask = dragonProjectileCategory
        turretNode.physicsBody?.contactTestBitMask = dragonProjectileCategory
        self.addChild(turretNode)
    }
    
    func loadAppearance_Dragon(){

        /*
        let dragonAnimatedAtlas = SKTextureAtlas(named: "greenDragonSprites")
        var flyFrames = [SKTexture]()
        let numImages = dragonAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let dragonTextureName = "greenDragon\(i)"
            flyFrames.append(dragonAnimatedAtlas.textureNamed(dragonTextureName))
        }
        dragonFlyFrames = flyFrames
        let firstFrame = dragonFlyFrames[0]
        */
        let dragonAnimatedAtlas = SKTextureAtlas(named: "redDragonSprites")
        var flyFrames = [SKTexture]()
        let numImages = dragonAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let dragonTextureName = "redDragon\(i)"
            flyFrames.append(dragonAnimatedAtlas.textureNamed(dragonTextureName))
        }
        dragonFlyFrames = flyFrames
        let firstFrame = dragonFlyFrames[0]
        
        let dragonNode = SKSpriteNode(texture: firstFrame)
        dragonNode.anchorPoint = CGPointMake(0.5, 0.5)
        //dragonNode.setScale(0.225)
        dragonNode.zPosition = 2
        dragonNode.position = loadRandSpawnLeft()
        dragonNode.name = "redDragon"
        dragonNode.physicsBody = SKPhysicsBody(texture: dragonNode.texture!, size: CGSizeMake(dragonNode.size.width, dragonNode.size.height))
        dragonNode.physicsBody?.affectedByGravity = false
        dragonNode.physicsBody?.dynamic = false
        dragonNode.physicsBody?.categoryBitMask = dragonCategory
        dragonNode.physicsBody?.collisionBitMask = bulletCategory
        dragonNode.physicsBody?.contactTestBitMask = bulletCategory
        //loadAppearance_DragonProjectile()
        //dragonLoadAppearance_healthbar()
        //dragonFlyAnimation()
        //dragonMoveRight()
        
        
        //self.addChild(dragonNode)
    }
    func loadAppearance_DragonProjectile(){
        let projectileAnimatedAtlas = SKTextureAtlas(named: "Eggs")
        var flyFrames2 = [SKTexture]()
        let numImages = projectileAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let eggTextureName = "Egg\(i)"
            flyFrames2.append(projectileAnimatedAtlas.textureNamed(eggTextureName))
        }
        eggFlyFrames = flyFrames2
        let firstFrame = eggFlyFrames[0]
        
        dragonProjectileNode = SKSpriteNode(texture: firstFrame)
        //dragonProjectileNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width * 0.065, self.frame.size.width * 0.065))
        dragonProjectileNode.setScale(0.65)
        dragonProjectileNode.position = dragonNode.position
        dragonProjectileNode.zPosition = 3
        dragonProjectileNode.name = "projectile"
        dragonProjectileNode.physicsBody = SKPhysicsBody(texture: dragonProjectileNode.texture!, size: CGSizeMake(dragonProjectileNode.size.width, dragonProjectileNode.size.height))
        dragonProjectileNode.physicsBody?.affectedByGravity = false
        dragonProjectileNode.physicsBody?.dynamic = true
        dragonProjectileNode.physicsBody?.categoryBitMask = dragonProjectileCategory
        dragonProjectileNode.physicsBody?.collisionBitMask = 0
        dragonProjectileNode.physicsBody?.contactTestBitMask = turretCategory
        //eggFlyAnimation()
        self.addChild(dragonProjectileNode)
        //eggMoveRight()
        //dragonNode.addChild(dragonProjectileNode)
    }
    
    func eggFlyAnimation(){
        dragonProjectileNode.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(eggFlyFrames, timePerFrame: 0.225)))
    }
    func shootProjectile(){
        
        //dragonProjectileNode.removeFromParent()
        //loadAppearance_DragonProjectile()
        dragonProjectileNode.physicsBody?.collisionBitMask = turretCategory
        //aim
        let dx = turretNode.position.x - dragonNode.position.x
        let dy = turretNode.position.y - dragonNode.position.y
        let angle = atan2(dy, dx)
        //dragonProjectileNode.zRotation = angle
        
        //Seek
        var vx = turretNode.position.x
        var vy = turretNode.position.y


        //dragonProjectileNode.removeFromParent()
        //shoot
        
        let delay = SKAction.waitForDuration(loadRandDropTime())
        let shootAction = SKAction.moveTo(CGPointMake(vx, vy),duration: projectileFlightSpeed)
        let sequence = SKAction.sequence([delay, shootAction])
        dragonProjectileNode.runAction(sequence)
        eggFlyAnimation()
        //dragonProjectileNode.removeFromParent()
        //dragonProjectileNode.hidden = false
        //dragonProjectileNode.runAction(SKAction.sequence([delay, shootAction]))
        //dragonProjectileNode.runAction(shootAction)
  
    }
    
    func dragonFlyAnimation(){
        dragonNode.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(dragonFlyFrames, timePerFrame: 0.125)))
    }
    func castleLoadAppearance_healthbar(){
        healthbarFrame = SKSpriteNode(imageNamed: "healthBarFrame")
        healthbarFrame.position = CGPointMake(self.frame.size.width * 0.670, self.frame.size.height * 0.8)
        healthbarFrame.setScale(2.0)
        healthbarFrame.xScale = (2.5)
        healthbarFrame.zPosition = 1
        healthbarFrame.anchorPoint = CGPointZero
        self.addChild(healthbarFrame)
        
        
        healthbar = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(self.frame.size.width * 0.26, self.frame.size.height * 0.0223))
        healthbar.zPosition = 1
        healthbar.anchorPoint = CGPointMake(0, 0.5)
        healthbar.position = CGPointMake(self.frame.size.width * 0.7, self.frame.size.height * 0.9615)
        self.addChild(healthbar)
    }
    func castleHealthRatioMonitor(){
        
    }
    
    func dragonAttack(){
        
    }
    
    func dragonMoveRight(){
        
        //collisionHappened = false
        
        destinationPoint = loadRandDestinationRight()
        
        print(destinationPoint, "dragon")
        
        let moveDragon = SKAction.moveTo(destinationPoint, duration: dragonFlightSpeed)
        //let xPoint = loadRandDropLocation()
        //loadAppearance_DragonProjectile()
        //print(xPoint)
        dragonNode.runAction(moveDragon)
        
        //var number = loadRandDropLocation()
        //print(number)
        
        
        //shootProjectile()
        //shootTimer = NSTimer.scheduledTimerWithTimeInterval(loadRandDropTime(), target: self, selector: #selector(shootProjectile), userInfo: nil, repeats: false)
        //print(loadRandDropTime())
            //shootProjectile(dragonProjectileNode)
            //shoot node at that nigga
 
    }
    
    func eggMoveRight(){
        
        print(destinationPoint, "egg")
        let moveEgg = SKAction.moveTo(destinationPoint, duration: dragonFlightSpeed)
        dragonProjectileNode.runAction(moveEgg)
    }
    func eggMoveRightSecond(){
        var myDoubleValue:Double = Double(dragonNode.position.x)
        let moveEgg = SKAction.moveTo(destinationPoint, duration: dragonFlightSpeed/myDoubleValue)
        dragonProjectileNode.runAction(moveEgg)
    }
    func loadRandDropTime() -> NSTimeInterval{
    
    //or minNodeTimeValue?
    var MinNodeSpawnValue = 1.0
    
    //or maxNodeTimeValue?
    var MaxNodeSpawnValue = dragonFlightSpeed - 2.15
    
    //or randomTime?
    var randomPoint = UInt32(MaxNodeSpawnValue - MinNodeSpawnValue)
        
    return (NSTimeInterval(arc4random_uniform(randomPoint)) + MinNodeSpawnValue)
    
        
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
    
    func addPhysicsWorld() {
        
        //amount of effect the gravity has
        //x is 0 for no side to side
        //-9.8 is gravity on Earth
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        //close off the frame with a physicsbody
        //sceneBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //friction - ball will bounce back at same speed
        sceneBody.friction = 0
        //apply physics body to scene
        self.physicsBody = sceneBody
        physicsWorld.contactDelegate = self
    }

    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == bulletCategory && secondBody.categoryBitMask == dragonCategory && collisionHappenedDragon_Bullet != true || firstBody.categoryBitMask == dragonCategory && secondBody.categoryBitMask == bulletCategory && collisionHappenedDragon_Bullet != true {
            
            if scopeNode.hidden == true {
                
                collisionHappenedDragon_Bullet = true
                scopeNode.removeFromParent()
                bulletNode.removeFromParent()
                
                loadAppearance_Bullet()
                
                score = score + 1
                scoreLabel.text = String(score)
                
                
                //dragonProjectileNode.removeFromParent()
                //dragonProjectileNode.removeFromParent()
                
                resetDragon()
                
            }
            
            if scopeNode.hidden != true{
                
                collisionHappenedDragon_Bullet = true
                dragonProjectileNode.removeFromParent()
                scopeNode.removeFromParent()
                bulletNode.removeFromParent()
                loadAppearance_Bullet()
            }
            
            if score == 4{
                dragonFlightSpeed = 5.25
                projectileFlightSpeed = 4.25
            }
            
            if score == 9{
                dragonFlightSpeed = 4.5
                projectileFlightSpeed = 3.75
            }
            
            if score == 14{
                dragonFlightSpeed = 3.75
                projectileFlightSpeed = 3.25
            }
            if score == 19{
                dragonFlightSpeed = 3.0
                projectileFlightSpeed = 2.75
            }
            if score == 24{
                dragonFlightSpeed = 2.25
                projectileFlightSpeed = 2.25
            }
            if score == 29{
                dragonFlightSpeed = 1.5
                projectileFlightSpeed = 1.75
            }
            view?.userInteractionEnabled = true
            //collisionHappened = false
        }
        if firstBody.categoryBitMask == dragonProjectileCategory && secondBody.categoryBitMask == turretCategory && collisionHappenedProjectile_Turret != true || firstBody.categoryBitMask == turretCategory && secondBody.categoryBitMask == dragonProjectileCategory && collisionHappenedProjectile_Turret != true{
            
            collisionHappenedProjectile_Turret = true
            dragonProjectileNode.removeFromParent()
            healthbar.runAction(SKAction.resizeToWidth(self.frame.size.width * 0.15, height: healthbar.size.height, duration: 0.25))
            print("you died")
            loadAppearance_DragonProjectile()
            eggMoveRight()
            //turretNode.runAction(SKAction.moveTo(CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.09), duration: 0))
            //turretNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.09)
        }
        if firstBody.categoryBitMask == bulletCategory && secondBody.categoryBitMask == dragonProjectileCategory && collisionHappenedProjectile_Bullet != true || firstBody.categoryBitMask == dragonProjectileCategory && secondBody.categoryBitMask == bulletCategory && collisionHappenedProjectile_Bullet != true {
            
            collisionHappenedProjectile_Bullet = true
            dragonProjectileNode.removeFromParent()
            
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        touching = false
        
        for touch: AnyObject! in touches {
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            
            if let name = touchedNode.name{
                
                touching = true
                if name == "self" || name == "redDragon" || name == "background"{
                    var dx = bulletNode.position.x - positionInScene.x
                    var dy = bulletNode.position.y - positionInScene.y
                    var angle = atan2(dy, dx) + CGFloat(M_PI_2)
                    
                    if(angle < 0){
                        angle = angle + 2 * CGFloat(M_PI)
                    }
                    bulletNode.hidden = false
                    bulletNode.zRotation = angle
                    loadAppearance_Scope()
                    scopeNode.position = positionInScene
                    colorizeScope(scopeNode)

                }

                /*if name == "projectile" && name != "self"{
                    dragonProjectileNode.removeFromParent()
                    touching = false
                    eggScore += 1
                    eggLabelScoreNode.text = String(eggScore)
                }*/
                if name == "MainMenu"{
                    let myScene = StartScene(size: CGSize(width: 1536, height: 2048))
                    myScene.scaleMode = .AspectFill
                    let reveal = SKTransition.fadeWithDuration(0.65)
                    self.view?.presentScene(myScene, transition: reveal)
                }
            }
        }
    
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)

            positionInScene = location
            scopeNode.runAction(SKAction.moveTo(positionInScene, duration: 0))
            var dx = bulletNode.position.x - positionInScene.x
            var dy = bulletNode.position.y - positionInScene.y
            var angle = atan2(dy, dx) + CGFloat(M_PI_2)
            
            if(angle < 0){
                angle = angle + 2 * CGFloat(M_PI)
            }

            bulletNode.zRotation = angle
        }

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touching == true {
            let shootAction = SKAction.moveTo(CGPointMake(1900 * -cos(bulletNode.zRotation - 1.57079633) + bulletNode.position.x,1900 * -sin(bulletNode.zRotation - 1.57079633) + bulletNode.position.y),duration: 0.74)
            view?.userInteractionEnabled = false
            scopeNode.removeAllActions()
            bulletNode.runAction(shootAction)
            
        }
        
        //view?.userInteractionEnabled = true
    }


   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        collisionHappenedDragon_Bullet = false
        collisionHappenedProjectile_Turret = false
        collisionHappenedProjectile_Bullet = false
        if dragonNode.position.x > self.frame.size.width * 0.9999999{
            
            resetDragon()
        }
        
        if bulletNode.position.y > self.frame.size.height || bulletNode.position.y < self.frame.size.height * 0.00001 || bulletNode.position.x < self.frame.size.width * 0.0000001 || bulletNode.position.x > self.frame.size.width{
            scopeNode.removeFromParent()
            resetBullet()
            }
        
        }
    

}
