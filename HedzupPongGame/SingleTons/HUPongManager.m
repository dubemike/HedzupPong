//
//  DMInstagramManager.m
//  Discovr
//
//  Created by Michael Dube on 2014/07/23.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "HUPongManager.h"
#import "globalConstants.h"



@implementation HUPongManager


static HUPongManager *sharedSingleton_ = nil;

+ (id)sharedInstance {
    
    @synchronized(self) {
        if (sharedSingleton_ == nil)
            sharedSingleton_ = [[self alloc] init];
    }
    
    return sharedSingleton_;
}

- (id)init {
    if (self = [super init]) {
        
        meddClass = [[ArchiverMediator alloc] init];
        
        //set up our sound files for preloading
        
        soundFiles = [[NSMutableDictionary alloc] init];
        
        [soundFiles setObject:[SKAction playSoundFileNamed:VOICE_WELCOME waitForCompletion:NO] forKey:VOICE_WELCOME];
        [soundFiles setObject:[SKAction playSoundFileNamed:VOICE_PRESS_ENTER waitForCompletion:NO] forKey:VOICE_PRESS_ENTER];
        [soundFiles setObject:[SKAction playSoundFileNamed:VOICE_HIGHSCORE waitForCompletion:NO] forKey:VOICE_HIGHSCORE];
        [soundFiles setObject:[SKAction playSoundFileNamed:VOICE_GAMEOVER waitForCompletion:NO] forKey:VOICE_GAMEOVER];
        [soundFiles setObject:[SKAction playSoundFileNamed:VOICE_FLOWER_POWER waitForCompletion:NO] forKey:VOICE_FLOWER_POWER];
        [soundFiles setObject:[SKAction playSoundFileNamed:SOUNDEFFECT_BALL_PLAYER waitForCompletion:NO] forKey:SOUNDEFFECT_BALL_PLAYER];
        [soundFiles setObject:[SKAction playSoundFileNamed:SOUNDEFFECT_BRICK_DIE waitForCompletion:NO] forKey:SOUNDEFFECT_BRICK_DIE];

        [soundFiles setObject:[SKAction playSoundFileNamed:SONG_ONE waitForCompletion:NO] forKey:SONG_ONE];
        [soundFiles setObject:[SKAction playSoundFileNamed:SONG_TWO waitForCompletion:NO] forKey:SONG_TWO];

        
     }
    
    return self;
}


-(void) playSoundFilewithName:(NSString*) name fromParentScene:(SKScene*) scene
{
    [scene runAction:[soundFiles objectForKey:name] withKey:name];  //play a sound

}

-(void) playSoundFilewithName:(NSString*) name fromParentNode:(SKNode*) node
{
    [node runAction:[soundFiles objectForKey:name] withKey:name];  //play a sound
    
}

-(void) addUserHighScore:(NSString*) userName andHighScore:(int) score{

         //save details to coredata
        [meddClass addUserHighScore:[NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",
                                     [NSNumber numberWithInt:score],@"score",
                                     [NSDate date],@"savedDate", nil]];
}


-(NSArray*) getAllUserHighScores {
   
    NSSortDescriptor *highToLow = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:FALSE];

    NSArray *allUSers = [[[NSArray alloc] initWithArray:[HighScores findAllObjectsInContext:[self getManagedObjectContextForUse]]] sortedArrayUsingDescriptors:[NSArray arrayWithObject:highToLow]] ;
     
    return allUSers;
    
 }

-(HighScores*) getHighestScore;
{
    NSSortDescriptor *highToLow = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:FALSE];
    
    NSArray *allUSers = [[[NSArray alloc] initWithArray:[HighScores findAllObjectsInContext:[self getManagedObjectContextForUse]]] sortedArrayUsingDescriptors:[NSArray arrayWithObject:highToLow]] ;
    
    if ([allUSers count]==0) {
        return nil;
    }
    
    
    return [allUSers objectAtIndex:0];
}


//database
-(NSManagedObjectContext*) getManagedObjectContextForUse{
  
    
     return [meddClass getManagedObjectContextForUse];
}





 
@end
