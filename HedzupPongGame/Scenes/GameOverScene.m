//
//  GameOverScene.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "GameOverScene.h"
#import "MainMenu.h"
#import "GameScene.h"
#import "HUPongManager.h"
#import "globalConstants.h"

@implementation GameOverScene
@synthesize gameOverLabelTimer,scoreUserName;

-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon withScore:(int) currentScore andUserEmail:(NSString*) email {
    self = [super initWithSize:size];
    
    if (self) {
     
        currentGameTime = 10;
        self.scoreUserName = email;
        [self setBackgroundColor:[NSColor blackColor]];
        
        SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"game-over-screen-bg"];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.xScale = 0.5;
        background.yScale = 0.5;
        [self addChild:background];
      
       HighScores *highestRecordedScore = [[HUPongManager sharedInstance] getHighestScore];
        //NSLog(@"hiestScore is %@",highestRecordedScore);
        
        if (highestRecordedScore) {
        
            if (currentScore > [highestRecordedScore.score integerValue]) {
              //play congrats voice
                [[HUPongManager sharedInstance] playSoundFilewithName:VOICE_HIGHSCORE fromParentScene:self];
   
            }else{
                //tell user to try again
                [[HUPongManager sharedInstance] playSoundFilewithName:VOICE_GAMEOVER fromParentScene:self];

            }
        }
        
        //show the score on screen
        
        SKLabelNode* pointsText =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        pointsText.fontSize = 41;
        [pointsText setText:@"Points"];
        pointsText.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height-435);
        [self addChild:pointsText];
        
    
        SKLabelNode *pointsLabel =  [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        pointsLabel.fontSize = 95;
        [self addChild:pointsLabel];
        
        [pointsLabel setText:[NSString stringWithFormat:@"%d",currentScore ]];
        pointsLabel.position =  CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height-385);
        [pointsLabel setFontColor:COLOR_HU_PINK];

    
    
        
        if (isWon) {
            gameOverStatus = WON;
         } else {
            gameOverStatus = LOST;
         }
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
 
    id wait = [SKAction waitForDuration:1];
    id run = [SKAction runBlock:^{
        [self countDown];
    }];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, run]]]];
    
}


-(void) countDown{
    currentGameTime --;
    currentGameTime = currentGameTime <=0 ? 0: currentGameTime;
    
    if (!gameOverLabelTimer) {
        gameOverLabelTimer = [SKLabelNode labelNodeWithFontNamed:@"8BIT WONDER"];
        gameOverLabelTimer.fontSize = 30;//90;
        gameOverLabelTimer.position = CGPointMake(CGRectGetMidX(self.frame), 50 ); //CGRectGetMidY(self.frame)-50
        [self addChild:gameOverLabelTimer];
    
    }
    [gameOverLabelTimer setText:[NSString stringWithFormat:@"%d",currentGameTime]];
    
    if (currentGameTime <=0) {
        [self showMainMenu];
    }
}
-(void) showMainMenu{
    
    MainMenu* mainHome = [[MainMenu alloc] initWithSize:self.frame.size];
    
    [self.view presentScene:mainHome];
    
}

-(void) tryAgain{
    
    GameScene* gameplayScene = [[GameScene alloc] initWithSize:self.frame.size];
    gameplayScene.currentUserName = scoreUserName;

    [self.view presentScene:gameplayScene];
    
}
-(void) keyDown:(NSEvent *)theEvent{
    //any key press will take you back to the main menu screen?
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    
    if ([theEvent keyCode] == 53) {
        //escape is back
        [self showMainMenu];
    }
    
    
    if ([theEvent keyCode] == 36 || [theEvent keyCode] ==  49) {
        //enter key or space is continue
        [self tryAgain];
    }

}


@end
