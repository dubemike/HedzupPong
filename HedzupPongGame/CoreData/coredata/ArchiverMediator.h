//
//  ArchiverMediator.h
//  tweetLine
//
//  Created by W&C Mac on 2011/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiverManager.h"
#import <dispatch/dispatch.h>
#import  <objc/objc-api.h>
#import <malloc/malloc.h>
#import "HighScores.h"


@interface ArchiverMediator : NSObject 
{
   NSDateFormatter* df; 
 }

 @property (nonatomic, retain)  IBOutlet ArchiverManager * archiveManager_;

//archiver mediator methods here
-(NSManagedObjectContext*) getManagedObjectContextForUse;

//important
- (void)mergeChanges:(NSNotification *)notification;
//user acounts
-(void) addUserHighScore:(NSDictionary*) data;
-(void) saveToPlist: (NSArray*) array;

@end
