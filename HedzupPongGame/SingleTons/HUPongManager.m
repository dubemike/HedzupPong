//
//  DMInstagramManager.m
//  Discovr
//
//  Created by Michael Dube on 2014/07/23.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "HUPongManager.h"



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
        
    }
    
    return self;
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




//database
-(NSManagedObjectContext*) getManagedObjectContextForUse{
  
    
     return [meddClass getManagedObjectContextForUse];
}





 
@end
