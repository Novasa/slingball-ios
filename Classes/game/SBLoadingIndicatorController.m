//
//  SBLoadingIndicatorController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/16/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBLoadingIndicatorController.h"

@implementation SBLoadingIndicatorController

- (id) init {
    if (self = [super init]) {
        _durationBetweenTicks = 0.25f; // in seconds
        _timeElapsedSincePreviousTick = 0;
        
        _indices = 3;
        _index = 0;
        
        _direction = 1;
    }
    return self;
}

- (void) step: (float) t delta: (float) dt { 
    _timeElapsedSincePreviousTick += dt;
    
    if (_timeElapsedSincePreviousTick >= _durationBetweenTicks) {
        _timeElapsedSincePreviousTick = 0;
        
        _index += _direction;
        
        if (_index > _indices - 1) {
            _index = _indices - 1;
            
            _direction = -_direction;
        } else if (_index < 0) {
            _index = 0;
            
            _direction = -_direction;
        }
    }
}

- (NSInteger) indexCount {
    return _indices;
}

- (NSInteger) indexForCurrentFrame {
    return _index;
}

@end
