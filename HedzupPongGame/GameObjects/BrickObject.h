//
//  BrickObject.h
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/05.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "HUPongGameObject.h"

@interface BrickObject : HUPongGameObject
{
    
}
@property (nonatomic)  int ScorePOint;
@property (nonatomic)  int hitCount;

@property (nonatomic)  BOOL isActive;

- (void) removeBrick;
-(void) setUpObjectInParent:(SKScene*) parent andWithColour:(NSColor*)color;

@end
