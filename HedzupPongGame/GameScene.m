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
@synthesize playerNode,currentScore,pointsLabel,leaderBoardImage,timerLabel,currentUserName;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = COLOR_HU_LIGHT_BLUE;
    
    lives = 2;
    currentScore = 0;
 
     //add our player object here
    self.playerNode = [PaddleBoard spriteNodeWithImageNamed: @"white-strip.png"];
    [self.playerNode setSize:CGSizeMake(100, 22)]; //35
    [self.playerNode setUpObjectInParent:self];
    leaderBoardScores = [[NSArray alloc] initWithArray:[[HUPongManager sharedInstance] getAllUserHighScores]] ;
    [self layOutInitialGameWorld];
    
    
    //show are u ready stuff
    SKLabelNode *pointScore = [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
    [pointScore setText:@"!!!!GET READY!!!!"];
    [pointScore setName:NAME_UPDATE_SCREEN_TEXT];
     pointScore.fontSize = 48;
     pointScore.position = CGPointMake(CGRectGetMidX(self.frame)-130, CGRectGetMidY(self.frame)-250);

    [self addChild:pointScore];
    
     SKAction * waitOne = [SKAction waitForDuration:3];
     SKAction * actionMoveDone = [SKAction removeFromParent];
     [pointScore runAction:[SKAction sequence:@[waitOne, actionMoveDone]]];
  
    
    
    id wait = [SKAction waitForDuration:3.2];
    id runGame = [SKAction runBlock:^{

        [self addBall];
    }];
    
    [self runAction:[SKAction sequence:@[wait, runGame]]];
    
    
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
     if (lives ==0) {
        [self showGameOverScene:NO];
    }
}


-(void) showGameOverScene:(BOOL) iWon{
   
    GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:iWon withScore:currentScore andUserEmail:self.currentUserName];
     [self.view presentScene:gameOverScene];
    
    //save the new high Score
    [[HUPongManager sharedInstance] addUserHighScore:self.currentUserName andHighScore:currentScore];

}

#pragma mark GameLayout methods 
-(void) layOutInitialGameWorld{
    //on startup we call this method to draw and layout out gameobjects
    playerNode.position = CGPointMake(CGRectGetMidX(self.frame)-137,
                                      10);
    currentGameTime = TOTALGAMETIME;
    
    id wait = [SKAction waitForDuration:1];
    id run = [SKAction runBlock:^{
        [self updateGameTime];

    }];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, run]]]];
  
    [self addBlocks];
    [self addFloor];
    //[self addBall];
    [self updateCurrentScore];
 
}

-(void) updateCurrentScore{
    if (!self.pointsLabel) {
        self.pointsLabel =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        pointsLabel.fontSize = 95;

        [self addChild:self.pointsLabel];
        
        SKLabelNode* pointsText =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        pointsText.fontSize = 41;
        [pointsText setText:@"Points"];
        pointsText.position = CGPointMake(self.frame.size.width-150, self.frame.size.height-335);
         [self addChild:pointsText];
 
    }
    
     [pointsLabel setText:[NSString stringWithFormat:@"%d",currentScore ]];
     pointsLabel.position =  CGPointMake(self.frame.size.width-150, self.frame.size.height-285);
     [self.pointsLabel setFontColor:COLOR_HU_PINK];

    [self updateDrawLeaderBoard];
    
}


-(void) updateDrawLeaderBoard{
    if (!self.leaderBoardImage) {
        SKTexture *playNow = [SKTexture textureWithImageNamed:@"leaderboard-banner.png"];
        self.leaderBoardImage = [SKSpriteNode spriteNodeWithTexture:playNow];
        leaderBoardImage.name = NAME_LEADER_BOARD_BANNER;
        leaderBoardImage.position = CGPointMake(self.frame.size.width-150, self.frame.size.height-380);
        leaderBoardImage.xScale = 0.5;
        leaderBoardImage.yScale = 0.5;
        [self addChild:leaderBoardImage];
    }
    
    //first loop thru and remove all the leaderboard node labels
    NSInteger count = [leaderBoardScores count];
    
    //we know they are in decreasing order, so  take top five
    if (count>7) {
        count = 7;
    }

    
    for (SKNode *child in [self children]) {
        if ([child.name isEqualToString:NAME_LEADER_BOARD_LABEL]) {
            [child removeFromParent];

        }
    }

    int padding = 40;
    //simplest draw nodes in the right order
    for (int pos = 0;pos<count; pos++) {
        HighScores *currentUserHigh = [leaderBoardScores objectAtIndex:pos];

        
        SKLabelNode* nameLabelRanking =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        nameLabelRanking.fontSize = 18;
        [nameLabelRanking setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
 
        SKLabelNode* pointLabel =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        pointLabel.fontSize = 20;
        [pointLabel setText:[currentUserHigh.score stringValue]];
        [pointLabel setFontColor:COLOR_HU_PINK];
        
        NSRange firstAt = [currentUserHigh.userName rangeOfString:@"@"];
        
        NSString *nameFull = [currentUserHigh.userName substringToIndex:firstAt.location];
        if (nameFull.length > 8) {
            nameFull = [nameFull substringToIndex:8];
        }
        
        [nameLabelRanking setText:[NSString stringWithFormat:@"%d. %@",pos+1,nameFull]];
        nameLabelRanking.position = CGPointMake(self.frame.size.width-270, self.frame.size.height-450-(padding*pos));  //x was 150(c) or 95(r)
        pointLabel.position = CGPointMake(self.frame.size.width-50, self.frame.size.height-450-(padding*pos));

        if ([currentUserHigh.userName isEqualToString:currentUserName]) {
            [pointLabel setFontColor:COLOR_HU_YELLOW];
            [nameLabelRanking setFontColor:COLOR_HU_YELLOW];

        }
        [self addChild:nameLabelRanking];
        [self addChild:pointLabel];


    }
}

-(void) updateGameTime{
    //our countdown is called every second
  //  currentGameTime --;
    
    //dont derecese the time when there is no ball on the screen
    BallObject* ball = (BallObject*)[self childNodeWithName:NAME_BALL_CATEGORY];
    if (ball) {
        currentGameTime --;

    }
    
    if (!self.timerLabel) {
        self.timerLabel =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        [self addChild:self.timerLabel];
        
        SKLabelNode* secondsLabel =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        secondsLabel.fontSize = 31;
        [secondsLabel setText:@"seconds"];
        secondsLabel.position = CGPointMake(self.frame.size.width-150, self.frame.size.height-170);

        [self addChild:secondsLabel];
     }
    
    [timerLabel setText:[NSString stringWithFormat:@"%d",currentGameTime <=0 ? 0: currentGameTime]];
    timerLabel.fontSize = 95;
    timerLabel.position = CGPointMake(self.frame.size.width-150, self.frame.size.height-120);

    if (currentGameTime ==0) {
        
        SKSpriteNode *toRemove = (SKSpriteNode*)[self childNodeWithName:NAME_UPDATE_SCREEN_TEXT];
        if (toRemove) {
            [toRemove removeAllActions];
            [toRemove removeFromParent];
        }
        
         BallObject* ball = (BallObject*)[self childNodeWithName:NAME_BALL_CATEGORY];
        if (ball) {
            [ball removeAllActions];
            [ball removeFromParent];
        }
        
        //gets called once
        SKLabelNode *pointScore = [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        pointScore.fontSize = 48;
        pointScore.position = CGPointMake(CGRectGetMidX(self.frame)-130, CGRectGetMidY(self.frame)-250);
        [pointScore setText:@"!!YOUR TIME IS UP!!"];
        [pointScore setName:NAME_UPDATE_SCREEN_TEXT];

        [self addChild:pointScore];
        
        SKAction * waitOne = [SKAction waitForDuration:3];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [pointScore runAction:[SKAction sequence:@[waitOne, actionMoveDone]]];
    
         id wait =  wait = [SKAction waitForDuration:3.2];
        
        id runGame = [SKAction runBlock:^{
            [self showGameOverScene:YES];

        }];
        
        [self runAction:[SKAction sequence:@[wait, runGame]]];
       
        
     }
    
    
}

-(void) addBall {
    BallObject* ball = [BallObject spriteNodeWithImageNamed: @"ball.png"];
    [ball setUpObjectInParent:self];
    ball.tag = lives;
    
   // ball.position = CGPointMake(CGRectGetMidX(self.frame),
     //                           self.frame.size.height-20);
    
     ball.position = CGPointMake(CGRectGetMidX(self.playerNode.frame),
                              self.playerNode.frame.origin.y +40);

}


-(void) addFloor{
    //lets create a physics body that boders the whole screen
 //our floor will have a white frame , thin drawn around it
    CGRect gameFrameWorld = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width - 300, self.frame.size.height);
    CGRect gameSideFrameWorld = CGRectMake(self.frame.size.width - 300,self.frame.origin.y, 300, self.frame.size.height);
    
    
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
    
    FlowerObject* flower = [FlowerObject spriteNodeWithImageNamed:@"1.png"];
    [flower setUpObjectInParent:self];
    flower.xScale = 0.5;
    flower.yScale = 0.5;
    flower.position  = CGPointMake(CGRectGetMidX(self.frame)-150, self.frame.size.height-60);
    flower.ScorePOint = 40;
   
    //blocks next to the flower
    int blockWidth = 111;
    float padding = 10.0f;

     float xOffset =  padding + blockWidth -30;
    float yOffset = self.frame.size.height * 0.9f;

    //left next to flower
  for (int i = 1; i < 5; i++) {

    BrickObject* block = [BrickObject spriteNodeWithColor:COLOR_HU_WHITE size:CGSizeMake(111, 32)];
      
      //left top
      if (i==1) {
          block.position = CGPointMake((i-1)*padding + xOffset, yOffset);
          [block setUpObjectInParent:self andWithColour:COLOR_HU_WHITE];

       }
      //right top
      if (i==2) {
          block.position = CGPointMake( block.frame.size.width + (i-1)*padding + xOffset , yOffset);
          [block setUpObjectInParent:self andWithColour:COLOR_HU_YELLOW];

       }
      
      
      //bottom left
      if (i==3) {
          block.position = CGPointMake( (i-2-1)*padding + xOffset,yOffset - block.size.height  - padding);
          [block setUpObjectInParent:self andWithColour:COLOR_HU_YELLOW];

       }
      
      //bottom right
      if (i==4) {
          block.position = CGPointMake(  block.frame.size.width + (i-2-1)*padding + xOffset, yOffset - block.size.height - padding);
          [block setUpObjectInParent:self andWithColour:COLOR_HU_BLUE];

          
      }
     block.ScorePOint = 30;

    }
    
     xOffset =  (padding + blockWidth -30)*5.5;

    //right next to flower
    for (int i = 1; i < 5; i++) {
        
        BrickObject* block = [BrickObject spriteNodeWithColor:COLOR_HU_YELLOW size:CGSizeMake(111, 32)];
        
        //left top
        if (i==1) {
            block.position = CGPointMake((i-1)*padding + xOffset, yOffset);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_WHITE];

        }
        //right top
        if (i==2) {
            block.position = CGPointMake( block.frame.size.width + (i-1)*padding + xOffset , yOffset);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_PINK];

        }
        
        
        //bottom left
        if (i==3) {
            block.position = CGPointMake( (i-2-1)*padding + xOffset,yOffset - block.size.height  - padding);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_PINK];

        }
        
        //bottom right
        if (i==4) {
            block.position = CGPointMake(  block.frame.size.width + (i-2-1)*padding + xOffset, yOffset - block.size.height - padding);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_BLUE];

            
        }
        block.ScorePOint = 30;
        
    }
    
      xOffset =  (padding + blockWidth -30)*3.5;
      yOffset = (self.frame.size.height * 0.9f)/1.2;

    //Middle Under the floor
    for (int i = 1; i < 5; i++) {
        
        BrickObject* block = [BrickObject spriteNodeWithColor:COLOR_HU_YELLOW size:CGSizeMake(111, 32)];
        [block setUpObjectInParent:self andWithColour:COLOR_HU_BLUE];
        
        //left top
        if (i==1) {
            block.position = CGPointMake((i-1)*padding + xOffset, yOffset);
        }
        //right top
        if (i==2) {
            block.position = CGPointMake( block.frame.size.width + (i-1)*padding + xOffset , yOffset);
        }
        
        
        //bottom left
        if (i==3) {
            block.position = CGPointMake( (i-2-1)*padding + xOffset,yOffset - block.size.height  - padding);
        }
        
        //bottom right
        if (i==4) {
            block.position = CGPointMake(  block.frame.size.width + (i-2-1)*padding + xOffset, yOffset - block.size.height - padding);
            
        }
        block.ScorePOint = 30;
        
    }
    
    //bottom left
    xOffset =  padding + blockWidth -30;
    yOffset = (self.frame.size.height * 0.9f)/1.7;

    for (int i = 1; i < 5; i++) {
        
        BrickObject* block = [BrickObject spriteNodeWithColor:COLOR_HU_YELLOW size:CGSizeMake(111, 32)];
        
        //left top
        if (i==1) {
            block.position = CGPointMake((i-1)*padding + xOffset, yOffset);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_WHITE];

        }
        //right top
        if (i==2) {
            block.position = CGPointMake( block.frame.size.width + (i-1)*padding + xOffset , yOffset);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_YELLOW];

        }
        
        
        //bottom left
        if (i==3) {
            block.position = CGPointMake( (i-2-1)*padding + xOffset,yOffset - block.size.height  - padding);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_BLUE];

        }
        
        //bottom right
        if (i==4) {
            block.position = CGPointMake(  block.frame.size.width + (i-2-1)*padding + xOffset, yOffset - block.size.height - padding);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_BLUE];

            
        }
        block.ScorePOint = 30;
        
    }
   
    
    //bottom Right
    xOffset =  (padding + blockWidth -30)*5.5;
    yOffset = (self.frame.size.height * 0.9f)/1.7;
    
    for (int i = 1; i < 5; i++) {
        
        BrickObject* block = [BrickObject spriteNodeWithColor:COLOR_HU_YELLOW size:CGSizeMake(111, 32)];
 
        
        //left top
        if (i==1) {
            block.position = CGPointMake((i-1)*padding + xOffset, yOffset);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_BLUE];

        }
        //right top
        if (i==2) {
            block.position = CGPointMake( block.frame.size.width + (i-1)*padding + xOffset , yOffset);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_YELLOW];

        }
        
        
        //bottom left
        if (i==3) {
            block.position = CGPointMake( (i-2-1)*padding + xOffset,yOffset - block.size.height  - padding);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_BLUE];
            }
        
        //bottom right
        if (i==4) {
            block.position = CGPointMake(  block.frame.size.width + (i-2-1)*padding + xOffset, yOffset - block.size.height - padding);
            [block setUpObjectInParent:self andWithColour:COLOR_HU_WHITE];
             
        }
        
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
          [firstBody.node removeFromParent];  //means
        
        SKSpriteNode *toRemove = (SKSpriteNode*)[self childNodeWithName:NAME_UPDATE_SCREEN_TEXT];
        if (toRemove) {
            [toRemove removeAllActions];
            [toRemove removeFromParent];
        }
        
        lives--;
        NSLog(@"lives are %d",lives);
        //show are u ready stuff
        SKLabelNode *pointScore = [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        pointScore.fontSize = 48;
        pointScore.position = CGPointMake(CGRectGetMidX(self.frame)-130, CGRectGetMidY(self.frame)-250);
        
        [self addChild:pointScore];
        
        SKAction * waitOne = [SKAction waitForDuration:3];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [pointScore runAction:[SKAction sequence:@[waitOne, actionMoveDone]]];
        
        [[HUPongManager sharedInstance] playSoundFilewithName:VOICE_HEDZUP fromParentScene:self];
        
        id wait = nil;
        if (lives==1) {
            [pointScore setText:@"!!!LAST CHANCE!!!"];
             wait = [SKAction waitForDuration:3.2];

         }
        
        if (lives<=0) {
            //play death music etc
            [pointScore setText:@"!!GAME OVER!!"];
             wait = [SKAction waitForDuration:5.2];

             
            SKLabelNode *myScore = [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
            myScore.fontSize = 48;
            myScore.position = CGPointMake(CGRectGetMidX(self.frame)-130, CGRectGetMidY(self.frame)-250);
            

        }
 
        id runGame = [SKAction runBlock:^{
               [self userDidDie];
               [self addBall];
        }];
        
        [self runAction:[SKAction sequence:@[wait, runGame]]];
        
        
        
        
 
    }
    
    if (firstBody.categoryBitMask == BALL_BITMASK && secondBody.categoryBitMask == PLAYER_BITMASK) {
         [self runAction:[SKAction playSoundFileNamed:@"nes-00-01.wav" waitForCompletion:NO]];  //play a sound
 
    }
    

    if (firstBody.categoryBitMask == BALL_BITMASK && secondBody.categoryBitMask == BRICKS_BITMASK) {
         BrickObject *currentBrick = (BrickObject*) secondBody.node;
        currentScore += currentBrick.ScorePOint;
         [self updateCurrentScore];
        [currentBrick removeBrick];

        if ([self isGameWon]) {
            [self showGameOverScene:YES];
         }else{
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
    //check the keys for keyboard presses
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
