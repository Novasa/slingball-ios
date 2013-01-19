//
//  SBSplashController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSplashController.h"

#import "NVGame.h"
#import "NVFullscreenFadeInOutController.h"

#import "SBGroups.h"

@implementation SBSplashController

- (id) init {
    if (self = [super init]) {
        _skipAfterDuration = 4.5f;
    }
    return self;
}

- (void) start {
    [super start];
    
    _timeStarted = current_time();
}

- (void) loadNextScene {
    //[[NVGame sharedGame] loadSceneFromFileNamed: @"Loading" async: NO];
    
    [[NVGame sharedGame] loadSceneFromFileNamed: @"Menu" async: NO];
    [[NVGame sharedGame] loadSceneAdditivelyFromFileNamed: @"Playing" async: NO];
}

- (void) initiateLoadingNextScene {
    if (_isInitiatingLoad) {
        return;
    }
    
    _isInitiatingLoad = YES;
    
    NVFullscreenFadeInOutController* fader = [self.database getComponentOfType: [NVFullscreenFadeInOutController class] 
                                                                     fromGroup: kGroupCamera];
    
    [fader fadeInAndOutWithDuration: 2.0f];
    //[fader fadeInWithDuration: 1];
    
    [self performSelector: @selector(loadNextScene) 
               withObject: nil 
               afterDelay: 1.0f];
}

- (void) step: (float) t delta: (float) dt { 
    if (!_isInitiatingLoad) {
        _timeSinceStarted = current_time() - _timeStarted;
        
        if (_timeSinceStarted > _skipAfterDuration) {
            [self initiateLoadingNextScene];
        }
    }
}

- (void) touchesBegan: (NSSet*) touches {
    if (_timeSinceStarted > 1.1f) {
        [self initiateLoadingNextScene];
    }
}

@end
