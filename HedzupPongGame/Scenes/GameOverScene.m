//
//  GameOverScene.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene
@synthesize gameOverLabelTimer;

-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon {
    self = [super initWithSize:size];
    
    if (self) {
     
        currentGameTime = 10;
        
        SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"game-over-screen-bg"];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.xScale = 0.5;
        background.yScale = 0.5;
        [self addChild:background];
        
        
        // 1
        gameOverLabelTimer = [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        gameOverLabelTimer.fontSize = 42;
        gameOverLabelTimer.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:gameOverLabelTimer];

        id wait = [SKAction waitForDuration:1];
        id run = [SKAction runBlock:^{
            [self countDown];
         }];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, run]]]];
        
        
        
        
        if (isWon) {
            gameOverStatus = WON;
         } else {
            gameOverStatus = LOST;
         }
    }
    return self;
}


-(void) countDown{
    currentGameTime --;
    currentGameTime = currentGameTime <=0 ? 0: currentGameTime;
     
    [gameOverLabelTimer setText:[NSString stringWithFormat:@"%d",currentGameTime]];
    gameOverLabelTimer.fontSize = 42;
    gameOverLabelTimer.position = CGPointMake(self.frame.size.width-200, self.frame.size.height-200);
    
    if (currentGameTime <=0) {
        [self showMainMenu];
    }
}
-(void) showMainMenu{
    
}
-(void) keyDown:(NSEvent *)theEvent{
    //any key press will take you back to the main menu screen?
    
}


@end
