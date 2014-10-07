//
//  GameOverScene.h
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum  {
 
    LOST = 0,
    WON = 1

} GAMEOVER;

@interface GameOverScene : SKScene
{
    GAMEOVER gameOverStatus;
    int currentGameTime ;
}
@property (nonatomic)  NSString* scoreUserName;
@property (nonatomic) SKLabelNode* gameOverLabelTimer;
-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon withScore:(int) currentScore andUserEmail:(NSString*) email;
@end
