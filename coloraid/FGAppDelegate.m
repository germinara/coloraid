//
//  FGAppDelegate.m
//  coloraid
//
//  Created by francesco on 7/31/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//

#import "FGAppDelegate.h"
#import "FGHSV.h"

@implementation FGAppDelegate

@synthesize window = _window;
@synthesize colorLookUpTable;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
 
    colorLookUpTable =[[NSMutableArray alloc] init];
 
    [self fillColorTable];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
 // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
 // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
 // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
 // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
 // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
 // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
 // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fill color table using Harbisson's Sonochromatic Scales for frequency and ColorADD Code - MIGUEL NEIVA
//////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) fillColorTable{
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"dd3b22" frequencyEq:363.797 imageEq:[UIImage imageNamed:@"colorADD-rosso.gif"] withName:NSLocalizedString(@"RED", nil)]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"730000"    frequencyEq:363.797 imageEq:[UIImage imageNamed:@"colorADD-rosso-scuro.gif"] withName:NSLocalizedString(@"DARKRED", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"fbb7c3"    frequencyEq:363.797 imageEq:[UIImage imageNamed:@"colorADD-rosso-chiaro.gif"] withName:NSLocalizedString(@"LIGHTRED", nil) ]];
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"7cb801"    frequencyEq:478.394 imageEq:[UIImage imageNamed:@"colorADD-verde.gif"] withName:NSLocalizedString(@"GREEN", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"144d29"    frequencyEq:478.394 imageEq:[UIImage imageNamed:@"colorADD-verde-scuoro.gif"] withName:NSLocalizedString(@"DARKGREEN", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"b9e55d"    frequencyEq:478.394 imageEq:[UIImage imageNamed:@"colorADD-verde-chiaro.gif"] withName:NSLocalizedString(@"LIGHTGREEN", nil) ]];
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"864dbe"    frequencyEq:607.542 imageEq:[UIImage imageNamed:@"colorADD-viola.gif"] withName:NSLocalizedString(@"VIOLET", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"501941"    frequencyEq:607.542 imageEq:[UIImage imageNamed:@"colorADD-viola-scuro.gif"] withName:NSLocalizedString(@"PURPLE", nil)  ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"cf4ba8"    frequencyEq:607.542 imageEq:[UIImage imageNamed:@"colorADD-viola-chiaro.gif"] withName:NSLocalizedString(@"ORCHID", nil)  ]];
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"f6a20b"   frequencyEq:440.195 imageEq:[UIImage imageNamed:@"colorADD-arancio.gif"] withName:NSLocalizedString(@"ORANGE", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"b95700"  frequencyEq:440.195 imageEq:[UIImage imageNamed:@"colorADD-arancio-scuro.gif"] withName:NSLocalizedString(@"BRICK", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"ffc664"  frequencyEq:440.195 imageEq:[UIImage imageNamed:@"colorADD-arancio-chiaro.gif"] withName:NSLocalizedString(@"LIGHTORANGE", nil) ]];
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"6d4700" frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-marrone.gif"] withName:NSLocalizedString(@"BROWN", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"4f2608" frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-marrone-scuoro.gif"] withName:NSLocalizedString(@"DARKBROWN", nil)]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"bcab74" frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-marrone-chiaro.gif"] withName:NSLocalizedString(@"KHAKI", nil) ]];
 
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"0047b9" frequencyEq:573.891 imageEq:[UIImage imageNamed:@"colorADD-blu.gif"] withName:NSLocalizedString(@"BLUE", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"191f56" frequencyEq:573.891 imageEq:[UIImage imageNamed:@"colorADD-blu-scuro.gif"] withName:NSLocalizedString(@"DARKBLUE", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"44baf0" frequencyEq:573.891 imageEq:[UIImage imageNamed:@"colorADD-blu-chiaro.gif"] withName:NSLocalizedString(@"LIGHTBLUE", nil)]];
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"f6df17" frequencyEq:462.023 imageEq:[UIImage imageNamed:@"colorADD-giallo.gif"] withName:NSLocalizedString(@"YELLOW", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"dbb634" frequencyEq:462.023 imageEq:[UIImage imageNamed:@"colorADD-giallo-scuro.gif"] withName:NSLocalizedString(@"DARKYELLOW", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"e7e282" frequencyEq:462.023 imageEq:[UIImage imageNamed:@"colorADD-giallo-chiaro.gif"] withName:NSLocalizedString(@"LIGHTYELLOW", nil) ]];
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"000000"   frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-nero.gif"] withName:NSLocalizedString(@"BLACK", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"ffffff" frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-bianco.gif"] withName:NSLocalizedString(@"WHITE", nil) ]];
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"8b8b8b"    frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-argento.gif"] withName:NSLocalizedString(@"SILVER", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"b99209" frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-oro.gif"] withName:NSLocalizedString(@"GOLD", nil)  ]];
 
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"414141" frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-grigio-scuro.gif"] withName:NSLocalizedString(@"DARKGRAY", nil) ]];
 [colorLookUpTable addObject:[[FGHSV alloc] initWithStringColor:@"d5d5d5"frequencyEq:0.0 imageEq:[UIImage imageNamed:@"colorADD-grigio-chiaro.gif"] withName:NSLocalizedString(@"LIGHTGRAY", nil) ]];
}


@end
