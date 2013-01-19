//
//  SBInstructionsController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/26/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBInstructionsController.h"

#import "SBInstructions.h"

#import "NVGame.h"
#import "NVInterpolator.h"

@implementation SBInstructionsController

@synthesize alpha = _alpha;

- (id) init {
    if (self = [super init]) {
        _alpha = 0;
    }
    return self;
}

- (void) interpolatorDidStep: (NVInterpolator*) interpolator {
    _alpha = _isFadingIn ? interpolator.weight : 1 - interpolator.weight;
}

- (void) fadeIn: (BOOL) fadeIn {
    if (_hasFadedOutOnce) {
        return;
    }
    
    SBInstructions* instructions = [self.database getComponentOfType: [SBInstructions class] fromGroup: self.group];
    
    instructions.isVisible = YES;
    
    NVInterpolator* interpolator = [[[NVGame sharedGame] scheduling] nextAvailableInterpolator];
    
    if (interpolator != nil) {
        interpolator.duration = fadeIn ? 1.5f : 1.0f;
        
        if ([interpolator beginWithDelegate: self]) {
            _isFadingIn = fadeIn;
            _isFadingOut = !fadeIn;
        }
    }
    
    _hasFadedOutOnce = !fadeIn;
}

- (void) fadeIn {
    [self fadeIn: YES];
}

- (void) fadeOut {
    [self fadeIn: NO];
}

@end
