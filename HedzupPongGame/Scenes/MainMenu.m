//
//  MainMenu.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/03.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"
#import "HUPongManager.h"

@implementation MainMenu
@synthesize userNameLabel;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
   
    currentState = PLAYGAME;
    currentTypedText = @"";
    
     SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"pong-bg.png"];
     SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
     background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
     background.xScale = 0.5;
     background.yScale = 0.5;
    [self addChild:background];

    //add the ping pong logo here as well
    SKTexture *logoImage = [SKTexture textureWithImageNamed:@"ping-pong-logo.png"];
    SKSpriteNode *logoLarge = [SKSpriteNode spriteNodeWithTexture:logoImage];
    logoLarge.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+170);
    logoLarge.xScale = 0.5;
    logoLarge.yScale = 0.5;
    [self addChild:logoLarge];

//    SKAction * scale = [SKAction scaleBy:1.5 duration:0.5];
//    SKAction * deScale = [SKAction scaleBy:0.5 duration:0.5];
//
//    SKAction * repeatUp = [SKAction repeatActionForever:scale];
//    SKAction * repeatDown = [SKAction repeatActionForever:deScale];
//
//    [logoLarge runAction:[SKAction sequence:@[scale,deScale]]];
//  
    
    [self setStateForView:currentState];
    
   // [[HUPongManager sharedInstance] playSoundFilewithName:SONG_ONE fromParentScene:self];

}


-(void)  setStateForView:(MENUSTATE) state
{
    
    switch (state) {
        case PLAYGAME:
        {
            [self.userNameLabel removeFromParent];
            SKSpriteNode *emailNowNowSprite = (SKSpriteNode*)[self childNodeWithName:NAME_EMAIL_FIELD];
            if (emailNowNowSprite) {
                [emailNowNowSprite removeFromParent];
            }
            
             [[HUPongManager sharedInstance] playSoundFilewithName:VOICE_WELCOME fromParentScene:self];
           
            //add the PLAY NOW LOGO
            SKTexture *playNow = [SKTexture textureWithImageNamed:@"playnow-with-flowers.png"];
            SKSpriteNode *playNowSprite = [SKSpriteNode spriteNodeWithTexture:playNow];
            playNowSprite.name = NAME_HOME_PLAY_NOW;
            playNowSprite.position = CGPointMake(CGRectGetMidX(self.frame), 140);
            playNowSprite.xScale = 0.5;
            playNowSprite.yScale = 0.5;
            [self addChild:playNowSprite];
             
        }break;
            
            
        case ENTER_USERNAME:{
            
            [[HUPongManager sharedInstance] playSoundFilewithName:VOICE_PRESS_ENTER fromParentScene:self];
            SKSpriteNode *playNowSprite = (SKSpriteNode*)[self childNodeWithName:NAME_HOME_PLAY_NOW];
            if (playNowSprite) {
                [playNowSprite removeFromParent];
             }
            [self layoutEnterUserName];
        } break;
            
        case START_GAME:{
            GameScene* gameplayScene = [[GameScene alloc] initWithSize:self.frame.size ];
            [self.view presentScene:gameplayScene];

        }
        case EXITGAME:
            
            break;
            
        default:
            break;
    }
    
    
}


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark Layout Options
-(void) layoutEnterUserName{
    //lets show
    if (!userNameLabel) {
             self.userNameLabel =  [SKLabelNode labelNodeWithFontNamed:@"Half Bold Pixel-7"];
        [self.userNameLabel setFontColor:[NSColor blackColor]];
            [self addChild:self.userNameLabel];
            userNameLabel.fontSize = 27;
        [self.userNameLabel setText:HOME_ENTER_EMAIL_TEXT];
     }
    
    
    SKTexture *playNow = [SKTexture textureWithImageNamed:@"emial-box-plain.png"];
    SKSpriteNode *playNowSprite = [SKSpriteNode spriteNodeWithTexture:playNow];
    playNowSprite.name = NAME_EMAIL_FIELD;
    playNowSprite.position = CGPointMake(CGRectGetMidX(self.frame), 140);
    playNowSprite.xScale = 0.5;
    playNowSprite.yScale = 0.5;
    [self addChild:playNowSprite];
    

    self.userNameLabel.position = CGPointMake(CGRectGetMidX(self.frame), playNowSprite.position.y -  10); ;

}




#pragma mark Handling Button Actions

-(IBAction) moveLeft:(id)sender{
    
    
}

-(IBAction) moveRight:(id)sender{
    
    
}


-(IBAction)moveUp:(id)sender{
    
}

-(IBAction)moveDown:(id)sender{
    
}
-(void) complete:(id)sender{
    NSLog(@"complete");
}


-(void) keyDown:(NSEvent *)theEvent{
   //escape keycode is 53, and enter is 36
     // Arrow keys are associated with the numeric keypad
     [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];

    if ([theEvent keyCode] == 53) {
        //escape is back
        if (currentState == ENTER_USERNAME){
            currentState = PLAYGAME;
            [self setStateForView:currentState];

        }
    }

    
    if ([theEvent keyCode] == 36 || [theEvent keyCode] ==  49) {
        //enter key or space is continue
        if (currentState == PLAYGAME){
            currentState = ENTER_USERNAME;
            [self setStateForView:currentState];
       
        }else  if (currentState == ENTER_USERNAME){
            if ([self validateEmailWithString:currentTypedText]) {
                currentState++;
                [self setStateForView:currentState];
            }else{
                //shake the label and play error sound
                
            }
        }
     }
    
     
 }

- (void)keyUp:(NSEvent *)event {

}

- (void)insertText:(id)string {
    
    [super insertText:string];  // have superclass insert it
    
    if (currentState==ENTER_USERNAME) {
        currentTypedText = [NSString stringWithFormat:@"%@%@",currentTypedText,string];
         [self.userNameLabel setText:currentTypedText];
     }
    
 }

- (void)deleteBackward:(id)sender{
    if (currentState==ENTER_USERNAME) {
        
        if (currentTypedText.length>0) {
            currentTypedText = [currentTypedText substringToIndex:currentTypedText.length-1];
        }
        
        if (currentTypedText.length==0){
            [self.userNameLabel setText:HOME_ENTER_EMAIL_TEXT];
            
        }else{
            [self.userNameLabel setText:currentTypedText];
   
        }
            
        
    }
}


-(void)mouseDown:(NSEvent *)theEvent {
    
 }

@end
