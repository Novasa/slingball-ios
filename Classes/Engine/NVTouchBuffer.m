//
//  NVTouchBuffer.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/10/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVTouchBuffer.h"

#import "SynthesizeSingleton.h"

@implementation NVTouchBuffer

SYNTHESIZE_SINGLETON_FOR_CLASS(NVTouchBuffer, Buffer);

- (id) init {
    if (self = [super init]) {
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches {
    _touchBuffered = [touches anyObject];
    
    CGPoint location = [_touchBuffered locationInView: _touchBuffered.view];
    
    _state.x = location.x;
    _state.y = location.y;
    _state.pressed = true;
    //_state.taps = _touchBuffered.tapCount;
    
    if (_isPlayingFrame) {
        _stateHasBeenModifiedDuringPreviousFrame = YES;
        _stateHasBeenAvailableForAtleastOneFrame = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches {
    if ([touches containsObject: _touchBuffered]) {
        CGPoint location = [_touchBuffered locationInView: _touchBuffered.view];
        
        _state.x = location.x;
        _state.y = location.y;
        
        if (_isPlayingFrame) {
            _stateHasBeenModifiedDuringPreviousFrame = YES;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches {
    if ([touches containsObject: _touchBuffered]) {
        _state.taps = _touchBuffered.tapCount;
        _touchBuffered = nil;
        
        _shouldFlushState = YES;
    }
}

- (void) begin {
    _isPlayingFrame = YES;
 
    if (!_stateHasBeenAvailableForAtleastOneFrame) {
        _stateHasBeenAvailableForAtleastOneFrame = YES;
    }
}

- (void) end {
    if (_shouldFlushState) {
        if (_stateHasBeenAvailableForAtleastOneFrame) {
            _shouldFlushState = NO;
            
            _state.x = 0;
            _state.y = 0;
            _state.taps = 0;
            _state.pressed = NO;
        }
    }
    
    _isPlayingFrame = NO;
}

- (NVTouchState) state {
    return NVTouchStateMake(_stateHasBeenAvailableForAtleastOneFrame ? _state.x : 0, 
                                  _stateHasBeenAvailableForAtleastOneFrame ? _state.y : 0, 
                                  _stateHasBeenAvailableForAtleastOneFrame ? _state.pressed : NO, 
                                  _stateHasBeenAvailableForAtleastOneFrame ? _state.taps : 0);
}

@end
