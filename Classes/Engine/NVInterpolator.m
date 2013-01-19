//
//  NVInterpolator.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/25/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVInterpolator.h"

@implementation NVInterpolator

@dynamic duration;

@synthesize weight = _weight;

@synthesize isAssigned = _isAssigned;
@synthesize hasEnded = _hasEnded;

@synthesize delegate = _delegate;

- (id) init {
    if (self = [super init]) {
        _duration = 0;
        _timeElapsedSinceStarting = 0;
        
        _isAssigned = NO;
        _hasEnded = NO;
        
        _stepSelector = @selector(interpolatorDidStep:);
        _finishSelector = @selector(interpolatorDidFinish:);
    }
    return self;
}

- (BOOL) beginWithDelegate: (id<NVInterpolatorDelegate>) delegate {
    if (_isAssigned) {
        return NO;
    }
    
    _delegate = delegate;
    
    _isAssigned = YES;
    _timeElapsedSinceStarting = 0;
    
    _hasEnded = NO;
    
    if (_delegate != nil) {
        _respondsToStepSelector = [_delegate respondsToSelector: _stepSelector];
        _respondsToFinishSelector = [_delegate respondsToSelector: _finishSelector];
    }
                               
    return YES;
}

- (void) end {
    if (_isAssigned) {
        _isAssigned = NO;
        _hasEnded = YES;
        
        if (_delegate != nil) {
            if (_respondsToFinishSelector) {
                [_delegate performSelector: _finishSelector
                                withObject: self];
            }
        }
    }
}

- (void) stepWithDeltaTime: (float) dt {
    _timeElapsedSinceStarting += dt;
    
    if (_timeElapsedSinceStarting > _duration) {
        _timeElapsedSinceStarting = _duration;
        
        [self end];
    }
    
    _weight = _timeElapsedSinceStarting / _duration;
    
    if (_delegate != nil) {
        if (_respondsToStepSelector) {
            [_delegate performSelector: _stepSelector 
                            withObject: self];
        }
    }
}

- (void) setDuration: (float) duration {
    if (_isAssigned) {
        return;
    }
    
    _duration = duration;
}

@end
