//
//  ballObject.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "BallObject.h"
#import "globalConstants.h"

@implementation BallObject
@synthesize maxSpeed,isActive,tag;


- (instancetype)init
{
    self = [super init];
    if (self) {
        maxSpeed = 1000;
        tag = 0;
    }
    return self;
}
-(id) initWithImageNamed:(NSString *)name
{
    self = [super initWithImageNamed:name];
     //set up our ball with correct physics etc
 return self;
 }

-(void) update{
    [super update];
    
//    /* Called before each frame is rendered */
//     float speed = sqrt(self.physicsBody.velocity.dx*self.physicsBody.velocity.dx + self.physicsBody.velocity.dy * self.physicsBody.velocity.dy);
//  //  NSLog(@"speed %f",speed);
//    if (speed > 500) {
//        self.physicsBody.linearDamping = 0.4f;
//    } else {
//        self.physicsBody.linearDamping = 0.0f;
//    }
}

-(void) setUpObjectInParent:(SKScene*) parent{

    [super setUpObjectInParent:parent];
    
    self.name = NAME_BALL_CATEGORY;
     self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width/2];
    self.physicsBody.friction = 0.0f;
    self.physicsBody.restitution = 1.0f;
    self.physicsBody.linearDamping = 0.0f;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.usesPreciseCollisionDetection = NO;
    self.physicsBody.categoryBitMask = BALL_BITMASK;
    self.physicsBody.contactTestBitMask = FLOOR_BITMASK | BRICKS_BITMASK;
    [self.physicsBody applyImpulse:CGVectorMake(2.0f, -2.0f)];
    isActive = true;
}

- (void) removeBall
{
    //play a sound on death
    
    SKAction * actionFade = [SKAction fadeAlphaTo:0 duration:0.1f];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    isActive = false;
    [self runAction:[SKAction sequence:@[actionFade, actionMoveDone]]];
    
}


@end
