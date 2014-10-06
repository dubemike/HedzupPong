//
//  AppDelegate.h
//  HedzupPongGame
//

//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface AppDelegate : NSResponder <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;

-(void) activateFonts;

@end
