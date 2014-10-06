//
//  GameScene.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/02.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "HUPongManager.h"
#import "HighScores.h"

@implementation GameScene

//synthesizers
@synthesize playerNode,currentScore,pointsLabel,timerLabel,currentUserName;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [SKColor blackColor];
    
    lives = 4;
    currentScore = 0;
 
     //add our player object here
    self.playerNode = [PaddleBoard spriteNodeWithImageNamed: @"white-strip.png"];
    [self.playerNode setSize:CGSizeMake(100, 35)];
    [self.playerNode setUpObjectInParent:self];

    [self layOutInitialGameWorld];
    
    // [[HUPongManager sharedInstance] addUserHighScore:@"dubemike@outlook.com" andHighScore:98];
    // HighScores *currentSavedScore = [[[HUPongManager sharedInstance] getAllUserHighScores] objectAtIndex:0];
   

}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (self.paused)
        return;
   
    for (SKNode* node in self.children) {
        if ([node isKindOfClass: [HUPongGameObject class]]) {
             HUPongGameObject* gameObject = (HUPongGameObject*) node;
            [gameObject update];
         }
    }
    
    
   
    
    
}


#pragma mark - game logic
-(void) userDidDie{
     lives --;
    
    if (lives <=0) {
        [self showGameOverScene:NO];
    }
}


-(void) showGameOverScene:(BOOL) iWon{
   
    GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:iWon];
    [self.view presentScene:gameOverScene];

}

#pragma mark GameLayout methods 
-(void) layOutInitialGameWorld{
    //on startup we call this method to draw and layout out gameobjects
    playerNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                      10);
    currentGameTime = TOTALGAMETIME;
    
    id wait = [SKAction waitForDuration:1];
    id run = [SKAction runBlock:^{
        [self updateGameTime];

    }];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, run]]]];
  
    [self addBlocks];
    [self addFloor];
    [self addBall];
    [self updateCurrentScore];
 
}

-(void) updateCurrentScore{
    if (!self.pointsLabel) {
        self.pointsLabel =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        [self addChild:self.pointsLabel];

    }
     [pointsLabel setText:[NSString stringWithFormat:@"%d",currentScore ]];
     pointsLabel.fontSize = 48;
    pointsLabel.position =  CGPointMake(self.frame.size.width-200, self.frame.size.height-300);
    
}

-(void) updateGameTime{
    //our countdown is called every second
    currentGameTime --;
    currentGameTime = currentGameTime <=0 ? 0: currentGameTime;
    
    if (!self.timerLabel) {
        self.timerLabel =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        [self addChild:self.timerLabel];
     }
    
    
    [timerLabel setText:[NSString stringWithFormat:@"%d",currentGameTime]];
    timerLabel.fontSize = 42;
    timerLabel.position = CGPointMake(self.frame.size.width-200, self.frame.size.height-200);

    if (currentGameTime <=0) {
        [self showGameOverScene:YES];
     }
    
    
}

-(void) addBall {
    BallObject* ball = [BallObject spriteNodeWithImageNamed: @"ball.png"];
    [ball setUpObjectInParent:self];
    ball.tag = lives;
    
   // ball.position = CGPointMake(CGRectGetMidX(self.frame),
     //                           self.frame.size.height-20);
    
     ball.position = CGPointMake(CGRectGetMidX(self.playerNode.frame),
                              self.playerNode.frame.origin.y +80);

}


-(void) addFloor{
    //lets create a physics body that boders the whole screen
 //our floor will have a white frame , thin drawn around it
    CGRect gameFrameWorld = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width - 400, self.frame.size.height);
    CGRect gameSideFrameWorld = CGRectMake(self.frame.size.width - 400,self.frame.origin.y, 400, self.frame.size.height);
    
    
    SKShapeNode *rectGameWorldSide = [SKShapeNode node];
    CGPathRef bodyPathSide = CGPathCreateWithRect(gameSideFrameWorld,nil);
    rectGameWorldSide.path = bodyPathSide;
    rectGameWorldSide.strokeColor = [SKColor whiteColor];
    rectGameWorldSide.lineWidth = 10.0;
    [self addChild:rectGameWorldSide];
    CGPathRelease(bodyPathSide);
    
    SKShapeNode *rectGameWorld = [SKShapeNode node];
    CGPathRef bodyPath = CGPathCreateWithRect(gameFrameWorld,nil);
    rectGameWorld.path = bodyPath;
    rectGameWorld.strokeColor = [SKColor whiteColor];
    rectGameWorld.lineWidth = 10.0;
    [self addChild:rectGameWorld];
    CGPathRelease(bodyPath);
    

    
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:gameFrameWorld];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
     
    CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
    SKNode* bottom = [SKNode node];
    bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
    [self addChild:bottom];
    bottom.physicsBody.categoryBitMask = FLOOR_BITMASK;
}

-(void) addBlocks{
    
       
    int blockWidth = [SKSpriteNode spriteNodeWithImageNamed:@"blocks.png"].size.width;
    float padding = 2.0f;
    // 2 Calculate the xOffset
    float xOffset = (self.frame.size.width - (blockWidth * WORLD_BLOCK_COUNT + padding * (WORLD_BLOCK_COUNT-1))) / 2;

    for (int i = 1; i < WORLD_BLOCK_COUNT; i++) {
        BrickObject* block = [BrickObject spriteNodeWithImageNamed:@"blocks.png"];
        [block setUpObjectInParent:self];
        block.position = CGPointMake((i-0.5f)*block.frame.size.width + (i-1)*padding + xOffset, self.frame.size.height * 0.8f);
        block.ScorePOint = 30;

    }
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // 3 react to the contact between ball and bottom
    if (firstBody.categoryBitMask == BALL_BITMASK && secondBody.categoryBitMask == FLOOR_BITMASK) {
       //  NSLog(@"Hit bottom.");
          [firstBody.node removeFromParent];  //means
          [self userDidDie];
 
    }
    
    if (firstBody.categoryBitMask == BALL_BITMASK && secondBody.categoryBitMask == PLAYER_BITMASK) {
         [self runAction:[SKAction playSoundFileNamed:@"nes-00-01.wav" waitForCompletion:NO]];  //play a sound
        //give it a little nudge up as well
       // [firstBody applyImpulse:CGVectorMake(firstBody.velocity.dx, firstBody.velocity.dy + 2.0f)];

    }
    

    if (firstBody.categoryBitMask == BALL_BITMASK && secondBody.categoryBitMask == BRICKS_BITMASK) {
         BrickObject *currentBrick = (BrickObject*) secondBody.node;
         currentScore += currentBrick.ScorePOint;
         [self updateCurrentScore];
         [currentBrick removeBrick];
        
        if ([self isGameWon]) {
            [self showGameOverScene:YES];
         }else{
            NSLog(@"DIDNT WIN");
        }
 
  
    }
}


-(BOOL)isGameWon {
    int numberOfBricks = 0;
    for (SKNode* node in self.children) {
        if ([node.name isEqual: NAME_BRICK_CATEGORY]) {
            BrickObject *currentBrick = (BrickObject*) node;
            if (currentBrick.isActive) {
                numberOfBricks++;
             }
            
        }
    }
    NSLog(@"block count %d",numberOfBricks);
    return numberOfBricks == 0 ? TRUE: FALSE;
}

#pragma mark Handling Button Actions

 -(IBAction) moveLeft:(id)sender{
 
 playerNode.physicsBody.velocity = CGVectorMake(0,0);
 [self.playerNode.physicsBody applyImpulse:CGVectorMake(-PLAYER_MOVE_VELOCITY_OFFSET,0)];
 
 }
 
 -(IBAction) moveRight:(id)sender{
 
 playerNode.physicsBody.velocity = CGVectorMake(0,0);
 [self.playerNode.physicsBody applyImpulse:CGVectorMake(PLAYER_MOVE_VELOCITY_OFFSET,0)];
 
 }

 
-(IBAction)moveUp:(id)sender{
    
}

-(IBAction)moveDown:(id)sender{
    
}
-(void) keyDown:(NSEvent *)theEvent{
    //check the keys for keyboard presses and add a velocity to the player node
    
    if ([theEvent modifierFlags] & NSNumericPadKeyMask) {
        [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    } else {
        [super keyDown:theEvent];
        
    }
}

 -(void)mouseDown:(NSEvent *)theEvent {
     [self addBall];
     
   //  [self setPaused:YES];
 }
 


@end
