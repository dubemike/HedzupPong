//
//  ballObject.h
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HUPongGameObject.h"


@interface BallObject : HUPongGameObject
{
    
}
@property (nonatomic)  int  maxSpeed;
@property (nonatomic)  BOOL isActive;
@property (nonatomic)  NSUInteger tag;

- (void) removeBall;

 @end
