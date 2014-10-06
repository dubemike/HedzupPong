//
//  Pong Manager
//
//  Created by Michael Dube on 2014/07/23.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiverMediator.h"
#import <SpriteKit/SpriteKit.h>


@interface HUPongManager : NSObject
{
    ArchiverMediator *meddClass;
    NSMutableDictionary *soundFiles;

}

+ (HUPongManager *) sharedInstance;

//databases and methods
-(NSManagedObjectContext*) getManagedObjectContextForUse;


//user accounts
-(void) addUserHighScore:(NSString*) userName andHighScore:(int) score;
-(NSArray*) getAllUserHighScores;
-(void) playSoundFilewithName:(NSString*) name fromParentScene:(SKScene*) scene;

@end
