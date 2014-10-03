//
//  GameScene.h
//  HedzupPongGame
//

//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "globalConstants.h"

//game objects here
#import "BallObject.h"
#import "PaddleBoard.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>
{
    
}

@property (nonatomic,retain) IBOutlet PaddleBoard *playerNode;

 -(void) addFloor;
@end
