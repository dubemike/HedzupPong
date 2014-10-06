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

@synthesize ScorePOint,isActive;


-(void) setUpObjectInParent:(SKScene*) parent{
    
    [super setUpObjectInParent:parent];
    isActive = TRUE;
    self.name = NAME_BRICK_CATEGORY;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.friction = 0.0f;
    self.name = NAME_BRICK_CATEGORY;
    self.physicsBody.categoryBitMask = BRICKS_BITMASK;
    [self.physicsBody setDynamic:NO];
     
}

-(void) removeBrick{
    //custom logic
    [self runAction:[SKAction playSoundFileNamed:@"nes-14-08.wav" waitForCompletion:NO]];  //play a sound
     SKAction * actionFade = [SKAction fadeAlphaTo:0 duration:0.2f];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    isActive = false;
    [self runAction:[SKAction sequence:@[actionFade, actionMoveDone]]];
    
}

@end
