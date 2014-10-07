//
//  FlowerObject.h
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/07.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "HUPongGameObject.h"

@interface FlowerObject : HUPongGameObject
{
    int hitCount;
}
@property (nonatomic)  int ScorePOint;
@property (nonatomic)  BOOL isActive;

- (void) removeBrick;
@end
