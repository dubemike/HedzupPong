//
//  paddleBoard.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "PaddleBoard.h"
#import "globalConstants.h"

@implementation PaddleBoard

-(id) initWithImageNamed:(NSString *)name
{
    self = [super initWithImageNamed:name];
    //set up our ball with correct physics etc
    
    return self;
    
    
}

-(void) update{
 
    
}

-(void) setUpObjectInParent:(SKScene*) parent{
    
    [super setUpObjectInParent:parent];
    
    self.name = NAME_PLAYER_CATEGORY;
    
    //add to view, and add properties like physics and body
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width , self.size.height)];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = PLAYER_BITMASK;
    self.physicsBody.contactTestBitMask = BALL_BITMASK;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = 0.1;
    self.physicsBody.friction = 0.4f;
 }



@end
