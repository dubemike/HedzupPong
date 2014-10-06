//
//  GameOverScene.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon {
    self = [super initWithSize:size];
    
    if (self) {
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:size];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        // 1
        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameOverLabel.fontSize = 42;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        if (isWon) {
            gameOverStatus = WON;
            gameOverLabel.text = @"Game Won";
        } else {
            gameOverStatus = LOST;
            gameOverLabel.text = @"Game Over";
        }
        [self addChild:gameOverLabel];
    }
    return self;
}


-(void) keyDown:(NSEvent *)theEvent{
    //any key press will take you back to the main menu screen?
    
}


@end
