//
//  MainMenu.h
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum  {
    
    PLAYGAME = 0,
    ENTER_USERNAME =1,
    START_GAME = 2,
    EXITGAME = 3
    
} MENUSTATE;

@interface MainMenu : SKScene
{
    MENUSTATE currentState;
    NSString *currentTypedText;
}

@property (nonatomic)  SKLabelNode* userNameLabel;

-(void)  setStateForView:(MENUSTATE) state;
- (BOOL)validateEmailWithString:(NSString*)email;

@end
