//
//  globalConstants.h
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#ifndef HedzupPongGame_globalConstants_h
#define HedzupPongGame_globalConstants_h

#ifdef PRPDEBUG
#define PRPLog(format...)NSLog(format)
#else
#define PRPLog(format...)
#endif

#define CMD_STR NSStringFromSelector(_cmd)
#define CLS_STR NSStringFromClass([self class])


#define BALL_BITMASK 0x1 << 0 // 00000000000000000000000000000001
#define FLOOR_BITMASK    0x1 << 1 // 00000000000000000000000000000010
#define PLAYER_BITMASK    0x1 << 2
#define BRICKS_BITMASK    0x1 << 3


//names of our game objects
#define NAME_BALL_CATEGORY @"ballObject"
#define NAME_PLAYER_CATEGORY @"playerObject"
#define NAME_BRICK_CATEGORY @"brickObject"

#define PLAYER_MOVE_VELOCITY_OFFSET 100.0f
#define WORLD_BLOCK_COUNT  40
#define SCORE_DEFAULT 40;
#define TOTALGAMETIME 120;

#define NUM_ROWS 6
#define NUMCOLS 9



#endif
