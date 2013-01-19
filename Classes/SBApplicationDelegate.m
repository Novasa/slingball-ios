//
//  SBApplicationDelegate.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright Novasa Interactive 2010. All rights reserved.
//

#import "SBApplicationDelegate.h"
#import "SBEAGLView.h"

@implementation SBApplicationDelegate

@synthesize window = _window;
@synthesize glView = _glView;

- (void) adjustOrientationAnimated: (BOOL) animated {
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (animated) {
        [UIView beginAnimations: nil context: NULL];
        [UIView setAnimationDuration: 0.666];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    }
    
	if (orientation == UIDeviceOrientationPortrait) {
        _glView.transform = CGAffineTransformIdentity;
	} else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        _glView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    if (animated) {
        [UIView commitAnimations];    
    }
}

- (void) orientationChanged: (NSNotification*) notification {
    [self adjustOrientationAnimated: YES];
}

- (BOOL) application: (UIApplication*) application didFinishLaunchingWithOptions: (NSDictionary*) launchOptions {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(orientationChanged:) 
                                                 name: @"UIDeviceOrientationDidChangeNotification" 
                                               object: nil];
  
    _window.backgroundColor = [UIColor colorWithRed: 35.0f / 255.0f 
                                              green: 40.0f / 255.0f 
                                               blue: 47.0f / 255.0f 
                                              alpha: 1];
    
    [self adjustOrientationAnimated: NO];
    
    [_glView startAnimation];
    
    return YES;
}

- (void)applicationWillResignActive: (UIApplication*) application {
    [_glView stopAnimation];
}

- (void)applicationDidBecomeActive: (UIApplication*) application {
    [_glView startAnimation];
}

- (void) applicationWillTerminate: (UIApplication*) application {
    [_glView stopAnimation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self 
                                                    name: @"UIDeviceOrientationDidChangeNotification" 
                                                  object: nil];
    
    [_window release];
    [_glView release];

    [super dealloc];
}

@end
