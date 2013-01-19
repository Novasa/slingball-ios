//
//  NVFullscreenFadeInOutController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVFullscreenFadeInOutController.h"

#import "NVRenderStates.h"

@implementation NVFullscreenFadeInOutController

@synthesize isAnimatingTransition = _isAnimatingTransition;

- (void) start {
    [super start];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NVRectFill(_screenSizedRectangle.rect, 0, 0, screenSize.width, screenSize.height);
    
    _screenSizedRectangle.isVisible = NO;
    _screenSizedRectangle.isOpaque = NO;
    //_screenSizedRectangle.layer = 999;
    _screenSizedRectangle.state = (unsigned int)(void*)state_fullscreen_rectangle;
    
    self.isEnabled = NO;
}

- (void) fadeIn: (BOOL) fadeIn withDuration: (float) duration {
    _timeStartedTransition = current_time();
    _transitionDuration = duration;
    _isAnimatingTransition = YES;
    _isFadingIn = fadeIn;
    
    _initialAlpha = fadeIn ? 0 : 1;
    _targetAlpha = fadeIn ? 1 : 0;
    
    self.isEnabled = YES;
    
    _screenSizedRectangle.isVisible = YES;
    _screenSizedRectangle.color->alpha = _initialAlpha;
}

- (void) fadeInWithDuration: (float) duration {
    [self fadeIn: YES withDuration: duration];
}

- (void) fadeOutWithDuration: (float) duration {
    [self fadeIn: NO withDuration: duration]; 
}

- (void) fadeInAndOutWithDuration: (float) duration {
    if (_isAnimatingTransition) {
        return;
    }
    
    _isFadingInAndOut = YES;
    
    [self fadeIn: YES withDuration: duration / 2];
}

- (void) step: (float) t delta: (float) dt {
    if (_isAnimatingTransition) {
        float const now = current_time();
        float timeElapsedSinceTransitionStart = now - _timeStartedTransition;
        
        if (timeElapsedSinceTransitionStart >= _transitionDuration) {
            timeElapsedSinceTransitionStart = _transitionDuration;
            
            if (_isFadingInAndOut) {
                _isFadingInAndOut = NO;
                _isAnimatingTransition = NO;
                
                [self fadeOutWithDuration: _transitionDuration];
            } else {
                _isAnimatingTransition = NO;
                
                self.isEnabled = NO;
                
                if (!_isFadingIn) {
                    _screenSizedRectangle.isVisible = NO;
                }
            }
        }
        
        float const amount = timeElapsedSinceTransitionStart / _transitionDuration;
        
        _screenSizedRectangle.color->alpha = lerp(_initialAlpha, _targetAlpha, amount);
    }
}

@end
