//
//  BrickObject.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/05.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "BrickObject.h"
#import "globalConstants.h"

@implementation BrickObject

@synthesize ScorePOint,isActive,hitCount;


-(void) setUpObjectInParent:(SKScene*) parent andWithColour:(NSColor*)color{
    
    [super setUpObjectInParent:parent];
    isActive = TRUE;
    self.name = NAME_BRICK_CATEGORY;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.friction = 0.0f;
    self.name = NAME_BRICK_CATEGORY;
    self.physicsBody.categoryBitMask = BRICKS_BITMASK;
    [self.physicsBody setDynamic:NO];
   
    [self setColor:color];

    if ([color isEqual: COLOR_HU_BLUE]) {
        hitCount = 4;
        self.ScorePOint = SCORE_BLUE;

    }else  if ([color isEqual: COLOR_HU_PINK ]) {
        hitCount = 3;
        self.ScorePOint = SCORE_PINK;

    }else  if ([color isEqual:  COLOR_HU_YELLOW]) {
        hitCount = 2;
        self.ScorePOint = SCORE_YELLOW;

    }else  if ([color isEqual:  COLOR_HU_WHITE]) {
        hitCount = 1;
        self.ScorePOint = SCORE_WHITE;

    }
}

-(void) removeBrick{
    
    
    //custom logic
    [self runAction:[SKAction playSoundFileNamed:SOUNDEFFECT_BRICK_DIE waitForCompletion:NO]];  //play a sound
    
    
     hitCount--;

    srandom(arc4random());
    int moveByYValue = random() % 200;  //random between 0 and 4
    
        //flip the textures around
        
        if (hitCount==4) {
            [self setColor:COLOR_HU_BLUE];
            self.ScorePOint = SCORE_BLUE;
            
        }
         if (hitCount==3) {
             [self setColor:COLOR_HU_PINK];
            self.ScorePOint = SCORE_PINK;
            
        }
        if (hitCount==2) {
            [self setColor:COLOR_HU_YELLOW];
            self.ScorePOint = SCORE_YELLOW;
            
        }
        if (hitCount==1) {
            [self setColor:COLOR_HU_WHITE];
            self.ScorePOint = SCORE_WHITE;
            
        }
        
        SKLabelNode *pointScore = [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        [pointScore setText:[NSString stringWithFormat:@"+%d",self.ScorePOint]];
        pointScore.fontSize = 18;
        [self addChild:pointScore];
        
        SKAction * actionFade = [SKAction fadeAlphaTo:0.1 duration:6.0f];
        SKAction * actionGrow = [SKAction scaleBy:4 duration:3.0f];
        SKAction * actionMove = [SKAction moveByX:0 y:moveByYValue  duration:1.2f];
        SKAction * wait = [SKAction waitForDuration:2];

        SKAction * actionMoveDone = [SKAction removeFromParent];
        isActive = false;
         [pointScore runAction:[SKAction group:@[actionFade,actionGrow, actionMove]]];
         [pointScore runAction:[SKAction sequence:@[wait, actionMoveDone]]];
     
     if (hitCount<= 0) {
         //we dead
        SKAction * actionFade = [SKAction fadeAlphaTo:0 duration:0.2f];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        isActive = false;
        [self runAction:[SKAction sequence:@[actionFade, actionMoveDone]]];
        
    }
    
}

@end
