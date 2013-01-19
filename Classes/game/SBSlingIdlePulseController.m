//
//  SBSlingIdlePulseController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingIdlePulseController.h"

#import "SBSlingIdlePulse.h"

@implementation SBSlingIdlePulseController

@synthesize scale = _scale;
@synthesize maxScale = _maxScale;

- (id) init {
    if (self = [super init]) {
        _scale = 0.0f;
        _maxScale = 0.5f;
        
        _speed = 1;
    
        _isIdle = YES;
        _durationUntilConsideredIdle = 1.5; // in seconds
    }
    return self;
}

- (void) step: (float) t delta: (float) dt {
    if (_isIdle) {
        _scale += _speed * dt;
        
        if (_scale > _maxScale) {
            _scale = 0;
        }   
    } else {
        if (_tailWasReleased) {
            _timePassedSinceTailWasReleased += dt;
            
            if (_timePassedSinceTailWasReleased > _durationUntilConsideredIdle) {
                _timePassedSinceTailWasReleased = 0;
                
                _isIdle = YES;
                
                if (_idlePulse != nil) {
                    _idlePulse.isVisible = YES;
                }
            }
        }
    }
}

- (void) update: (float) elapsed interpolation: (float) alpha {
    if (_idlePulse == nil) {
        _idlePulse = [self.database getComponentOfType: [SBSlingIdlePulse class] fromGroup: self.group];
    }
    
    BOOL idlePulseWasVisible = _idlePulse.isVisible;
    
    if (idlePulseWasVisible && _slingController.isDraggingTail) {
        _tailWasReleased = NO;
        _scale = 0;
        
        _idlePulse.isVisible = NO;
    } else if (!idlePulseWasVisible && !_slingController.isDraggingTail) {
        _isIdle = NO;
        
        _tailWasReleased = YES;
    }
}

@end
