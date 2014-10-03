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
}


-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon;

@end
