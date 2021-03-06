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
#import "BrickObject.h"
#import "FlowerObject.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>
{
    int lives;
    int currentGameTime;
    NSArray *leaderBoardScores;
    BOOL gameOverNow;
    int invulnTime;
 }

@property (nonatomic,retain) IBOutlet PaddleBoard *playerNode;
@property (nonatomic)  int currentScore;
@property (nonatomic)  BOOL isInvuln;

@property (nonatomic)  SKLabelNode* timerLabel;
@property (nonatomic)  SKLabelNode* pointsLabel;
@property (nonatomic)  SKSpriteNode* leaderBoardImage;
@property (nonatomic)  SKLabelNode *pointScoreOnScreen;
@property (nonatomic)  NSString* currentUserName;

-(void) layOutInitialGameWorld;

@end
