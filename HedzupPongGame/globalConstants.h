//
//  globalConstants.h
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#ifndef HedzupPongGame_globalConstants_h
#define HedzupPongGame_globalConstants_h


#define BALL_BITMASK 0x1 << 0
#define FLOOR_BITMASK    0x1 << 1
#define PLAYER_BITMASK    0x1 << 2
#define BRICKS_BITMASK    0x1 << 3


//names of our game objects
#define NAME_BALL_CATEGORY @"ballObject"
#define NAME_PLAYER_CATEGORY @"playerObject"
#define PLAYER_MOVE_VELOCITY_OFFSET 100.0f
#endif
