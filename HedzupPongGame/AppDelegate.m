//
//  AppDelegate.m
//  HedzupPongGame
//
//  Created by Michael Dube on 2014/10/02.
//  Copyright (c) 2014 tappnology. All rights reserved.
//

#import "AppDelegate.h"
#import "GameScene.h"
#import "MainMenu.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
        
    return scene;
}

@end

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self activateFonts];
    
   // GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    //scene.currentUserName = @"dubemike@outlook.com";

     MainMenu *scene = [MainMenu unarchiveFromFile:@"MainMenu"];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;
    
    self.skView.showsFPS = NO;
    self.skView.showsNodeCount = NO;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

-(void) keyDown:(NSEvent *)theEvent{
    //escape keycode is 53, and enter is 36
    // Arrow keys are associated with the numeric keypad
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
 }

-(void) activateFonts
{
    NSString *fontFilePath =[[NSBundle mainBundle] resourcePath] ;
    
    NSURL *fontsURL = [NSURL fileURLWithPath:fontFilePath];
    
    if(fontsURL != nil)
    {
        
        OSStatus status;
        FSRef fsRef;
        CFURLGetFSRef((CFURLRef)fontsURL, &fsRef);
        
        status=ATSFontActivateFromFileReference(&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified,NULL, kATSOptionFlagsDefault, NULL);
        
        if (status != noErr)
        {
            NSLog(@"Failed to acivate fonts! %d",status);
        }else{
            NSLog(@"Successfully Activated Font's");
            
        }
        
        
    }
}



@end
