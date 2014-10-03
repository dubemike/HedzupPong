//
//  GameScene.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/02.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

//synthesizers
@synthesize playerNode;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.gravity = CGVectorMake(0,-0.7f);
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [SKColor blackColor];
    
     //add our player object here
    self.playerNode = [PaddleBoard spriteNodeWithImageNamed: @"white-strip.png"];
    [self.playerNode setUpObjectInParent:self];
    playerNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
  
    
    [self addFloor];
    [self addBall];
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}




#pragma mark important methods
-(void) addBall {
    BallObject* ball = [BallObject spriteNodeWithImageNamed: @"ball.png"];
    [ball setUpObjectInParent:self];
}
 

-(void) addFloor{
    //lets create a physics body that boders the whole screen
    // 1 Create a physics body that borders the screen
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
     
    CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
    SKNode* bottom = [SKNode node];
    bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
    [self addChild:bottom];
    bottom.physicsBody.categoryBitMask = FLOOR_BITMASK;
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
        //TODO: Replace the log statement with display of Game Over Scene
        NSLog(@"Hit bottom. First contact has been made");
    }
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
 
 }
 


@end
