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

#define COLOR_HU_PINK [NSColor colorWithRed:249.0/255.0 green:85.0/255.0 blue:190.0/255.0 alpha:1]
#define COLOR_HU_LIGHT_BLUE [NSColor colorWithRed:88.0/255.0 green:193.0/255.0 blue:1 alpha:1]
#define COLOR_HU_BLUE [NSColor colorWithRed:76.0/255.0 green:68.0/255.0 blue:229.0/255.0 alpha:1]
#define COLOR_HU_WHITE [NSColor colorWithRed:1 green:1 blue:1 alpha:1]
#define COLOR_HU_YELLOW [NSColor colorWithRed:1 green:1 blue:131.0/255.0 alpha:1]

#define SCORE_BLUE 10
#define SCORE_PINK 6
#define SCORE_YELLOW 3
#define SCORE_WHITE 2

//names of our game objects
#define NAME_BALL_CATEGORY @"ballObject"
#define NAME_PLAYER_CATEGORY @"playerObject"
#define NAME_BRICK_CATEGORY @"brickObject"
#define NAME_HOME_PLAY_NOW @"playnowWithFlower"
#define NAME_EMAIL_FIELD @"EmailFieldPlain"
#define NAME_LEADER_BOARD_BANNER @"leaderBanner"
#define NAME_LEADER_BOARD_LABEL @"leaderBannerLabels"

#define PLAYER_MOVE_VELOCITY_OFFSET 100.0f
#define WORLD_BLOCK_COUNT  21
#define SCORE_DEFAULT 3;
#define TOTALGAMETIME 30;

//TEXT
#define HOME_ENTER_EMAIL_TEXT @"ENTER EMAIL & PRESS ENTER"

#define ENGILISH TRUE



#if ENGILISH
    #define VOICE_WELCOME @"british_intro.caf"
    #define VOICE_PRESS_ENTER @"british_press_enter.caf"
    #define VOICE_HIGHSCORE @"british_high_score.caf"
    #define VOICE_GAMEOVER @"british_game_over.caf"
    #define VOICE_FLOWER_POWER @"british_flower_power.caf"
    #define SOUNDEFFECT_BALL_PLAYER @"nes-00-01.wav"
    #define SOUNDEFFECT_BRICK_DIE @"nes-14-08.wav"



#else
    #define VOICE_WELCOME @"chinese_intro.wav"
    #define VOICE_PRESS_ENTER @"chinese_why_you_no_press_enter.caf"
    #define VOICE_HIGHSCORE @"british_high_score.caf"

#endif

#define SONG_ONE @"Magical_8bit_tour_.mp3"
#define SONG_TWO @"Everything_Is_Awesome.mp3"

#endif
