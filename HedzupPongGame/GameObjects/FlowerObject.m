//
//  FlowerObject.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/07.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "FlowerObject.h"
#import "globalConstants.h"

@implementation FlowerObject
@synthesize ScorePOint,isActive;


-(void) setUpObjectInParent:(SKScene*) parent{
    
    [super setUpObjectInParent:parent];
    isActive = TRUE;
    hitCount = 6;
    self.name = NAME_BRICK_CATEGORY;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width/2];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.friction = 0.0f;
    self.name = NAME_BRICK_CATEGORY;
    self.physicsBody.categoryBitMask = BRICKS_BITMASK;
    [self.physicsBody setDynamic:NO];
    
}

-(void) removeBrick{
   
    [self runAction:[SKAction playSoundFileNamed:VOICE_FLOWER_POWER waitForCompletion:NO]];  //play a sound
    hitCount--;
    
    if (hitCount<0) {
        //we dead
        SKAction * actionFade = [SKAction fadeAlphaTo:0 duration:0.2f];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        isActive = false;
        [self runAction:[SKAction sequence:@[actionFade, actionMoveDone]]];
        
    }else{
        //flip the textures around
        NSString *textName = @"1.png";
        
        if (hitCount==5) {
            textName = @"2.png";
            self.ScorePOint = 50;

        }
        if (hitCount==4) {
            textName = @"3.png";
            self.ScorePOint = 55;

        }
        if (hitCount==3) {
            textName = @"4.png";
            self.ScorePOint = 60;

        }
        if (hitCount==2) {
            textName = @"5.png";
            self.ScorePOint = 70;

        }
        if (hitCount==1) {
            textName = @"6.png";
            self.ScorePOint = 75;

        }
        
        if (hitCount<=0) {
            textName = @"6.png";
            self.ScorePOint = 90;
            isActive = FALSE;

        }
        
        //we animate a cool shake effect here
        
         SKTexture *flowerNow = [SKTexture textureWithImageNamed:textName];
         [self setTexture:flowerNow];
        
    }
    
}

@end
