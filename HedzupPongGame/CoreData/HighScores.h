//
//  HighScores.h
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/06.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HighScores : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSDate * savedDate;

@end
