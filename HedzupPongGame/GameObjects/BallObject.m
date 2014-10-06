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
    
    //CGFloat rate = .05;
   // CGVector relativeVelocity = CGVectorMake(200-self.physicsBody.velocity.dx, 200-self.physicsBody.velocity.dy);
     //self.physicsBody.velocity=CGVectorMake(self.physicsBody.velocity.dx+relativeVelocity.dx*rate, self.physicsBody.velocity.dy+relativeVelocity.dy*rate);
     float speed = sqrt(self.physicsBody.velocity.dx*self.physicsBody.velocity.dx + self.physicsBody.velocity.dy * self.physicsBody.velocity.dy);
     if (speed > 500) {
        self.physicsBody.linearDamping = 0.4f;
    } else {
        self.physicsBody.linearDamping = 0.0f;
     }
}

-(void) setUpObjectInParent:(SKScene*) parent{

    [super setUpObjectInParent:parent];

   srandom(arc4random());
    int n = random() % 4;  //random between 0 and 4
  
    self.name = NAME_BALL_CATEGORY;
     self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width/2];
    self.physicsBody.friction = 0.0f;
    self.physicsBody.restitution = 1.0f;
    self.physicsBody.linearDamping = 0.0f;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.usesPreciseCollisionDetection = NO;
    self.physicsBody.categoryBitMask = BALL_BITMASK;
    self.physicsBody.contactTestBitMask = FLOOR_BITMASK | BRICKS_BITMASK;
    [self.physicsBody setAffectedByGravity:NO];
    isActive = true;

    if (n==0)
        [self.physicsBody applyImpulse:CGVectorMake(-2.4f, -2.2f)];
     if (n==1)
        [self.physicsBody applyImpulse:CGVectorMake(2.0f, -2.0f)];
    if (n==2)
        [self.physicsBody applyImpulse:CGVectorMake(2.3f, -2.1f)];
    if (n==3)
        [self.physicsBody applyImpulse:CGVectorMake(-2.0f, -2.0f)];
    
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
