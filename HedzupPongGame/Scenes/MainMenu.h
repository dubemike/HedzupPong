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
    EXITGAME = 1
    
} MENUSTATE;

@interface MainMenu : SKScene
{

    MENUSTATE currentState;
}
@end
