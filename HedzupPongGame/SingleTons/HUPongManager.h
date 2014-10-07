//
//  Pong Manager
//
//  Created by Michael Dube on 2014/07/23.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiverMediator.h"
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HUPongManager : NSObject
{
    ArchiverMediator *meddClass;
    NSMutableDictionary *soundFiles;
    AVAudioPlayer *player ;
}

+ (HUPongManager *) sharedInstance;

//databases and methods
-(NSManagedObjectContext*) getManagedObjectContextForUse;


//user accounts
-(void) addUserHighScore:(NSString*) userName andHighScore:(int) score;
-(NSArray*) getAllUserHighScores;
-(HighScores*) getHighestScore;

-(void) playSoundFilewithName:(NSString*) name fromParentScene:(SKScene*) scene;
-(void) playSoundFilewithName:(NSString*) name fromParentNode:(SKNode*) node;

-(void) playBackGroundSongWithName:(NSString*) name;
@end
