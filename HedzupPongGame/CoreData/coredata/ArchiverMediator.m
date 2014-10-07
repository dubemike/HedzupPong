

//
//  ArchiverMediator.m
//  tweetLine
//
//  Created by W&C Mac on 2011/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ArchiverMediator.h"
#import "globalConstants.h"

#define LOGGING FALSE

/*
 0.01 fixes
 
 Stability fixes
 No diary(The Dreaded wooden background) on new/reinstall of tweetary
 Deleted diary accounts will not return on startupare now optional
 
 */

//This implementation is for Instagram :D

/* this should be your own implementation of this class, so change it as you see fit to your project, this will sit inbetween and send save requests to the archiverManager class
 
 */

/* THIS CLASS INTERCEPTS INCOMING REQESTS From AND SENDS THEM OFF FOR SAVING THIS IS ALL DONE IN THE BACKGROUND VIA THREADS, PARENTS MUST REGISTER FOR CONTEXT CHANGES TO BE ALERTED WHEN THERE IS NEW DATA IN THE CONTEXT */
@interface ArchiverMediator ()  <NSObject>

-(NSManagedObjectContext*) manageObjectContextForThreadSaving;

@end


@implementation ArchiverMediator


@synthesize archiveManager_;

-(id) init{
    
    //init anything you want here
    archiveManager_ = [[ArchiverManager alloc] init] ;
    
    df = [[NSDateFormatter alloc] init] ;
    [df setTimeStyle:NSDateFormatterFullStyle];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_ZA"] ] ;
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [df setLocale:[NSLocale currentLocale]];
 
    
    return  self;
}

-(NSManagedObjectContext*) getManagedObjectContextForUse
{
    
    return [archiveManager_  getManagedObjectContext];
}


#pragma mark Coredata methods

- (void)mergeChanges:(NSNotification *)notification
{
    if(![NSThread isMainThread]){
        //   NSLog(@"mergeChanges Not the main thread...");
        [self performSelectorOnMainThread:@selector(mergeChanges:) withObject: notification waitUntilDone:YES];
        
        return;
    }
    
    NSManagedObjectContext *mainContext = [archiveManager_  getManagedObjectContext];
    [mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    
    [mainContext performBlock:^{
        [mainContext mergeChangesFromContextDidSaveNotification:notification];
    }];
    
    
    
}

-(NSManagedObjectContext*) manageObjectContextForThreadSaving{
  
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [ctx setUndoManager:nil];
    [ctx setPersistentStoreCoordinator: [[archiveManager_ getManagedObjectContext] persistentStoreCoordinator]];
    [ctx setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [ctx setRetainsRegisteredObjects:YES];
    
    // Register context with the notification center
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(mergeChanges:)
               name:NSManagedObjectContextDidSaveNotification
             object:ctx];
    
    return ctx;
}

-(HighScores*) getUserWithId:(NSString*) userId InContext:(NSManagedObjectContext*) ctx{
    
    NSArray *allUSers = [[NSArray alloc] initWithArray:[HighScores findAllObjectsInContext:ctx]]  ;
    HighScores *currentUser = nil ;    //then check for duplicates
    
    for (int a=0; a<[allUSers count]; a++) {
        HighScores *temp = [allUSers objectAtIndex:a];
        if ([[temp.userName lowercaseString] isEqualToString:[userId lowercaseString]]) {
            
            currentUser = [allUSers objectAtIndex:a];
        }
        
    }
    return currentUser;
}

#pragma  mark - saving user accounts
-(void) addUserHighScore:(NSDictionary*) data{

    NSManagedObjectContext *ctx = [self manageObjectContextForThreadSaving];
    
    
//fetch to see if we can find said user, else just create a new user account
    HighScores *currentUserScore = [self getUserWithId:[data objectForKey:@"userName"] InContext:ctx];
    
    if (currentUserScore) {
        //highscore, only save it if its higher than the current score
        if ([currentUserScore.score integerValue] < [[data valueForKey:@"score"] integerValue]) {
            [currentUserScore safeSetValuesForKeysWithDictionary:data dateFormatter:df];
         }
        //update number of playthrus
        int currentPlayCount = [currentUserScore.numberOfPlays intValue];
        currentPlayCount ++;
        [currentUserScore setValue:[NSNumber numberWithInt:currentPlayCount] forKey:@"numberOfPlays"];

    }else{
        HighScores *newUserAccount = [[HighScores alloc] initWithEntity: [NSEntityDescription entityForName:@"HighScores" inManagedObjectContext:ctx] insertIntoManagedObjectContext:ctx];
        [newUserAccount safeSetValuesForKeysWithDictionary:data dateFormatter:df];
     }
    
    
    //Whew, its been a long time coming but here we go
    //Save this in database
    [ctx performBlock:^{
        NSError *error;
        if ([ctx save:&error ]) {
             NSLog(@"\n CTX GOOD SAVE [%@ %@]",CLS_STR,CMD_STR);
        } else
        {
             NSLog(@"\n CTX GOOD SAVE %@ [%@ %@]",error,CLS_STR,CMD_STR);
            
        }
        [ctx reset];
        
    }];


    //export to documents libray
    

}


@end