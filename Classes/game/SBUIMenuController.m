//
//  SBUIMenuController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuController.h"

#import "NVAudioCache.h"

#import "SBGlobalAudioSource.h"

@implementation SBUIMenuController

// TODO: should use time rather than arbitrary value for animating slide (time-based makes it animate at the same speed
// on any device)

@synthesize slideOutLeft = _slideOutLeft;
@synthesize isSlidIn = _isSlidIn;

- (id) init {
    if (self = [super init]) {
        _animationSpeed = 1100;
        
        _isSlidIn = YES;
        _slideOutLeft = YES;
    }
    return self;
}

- (void) start {
    [super start];
    
    _originX = _menuItem.rect->x;
}

- (void) toggleSlideInOut {
    if (_isSlidIn) {
        [self slideOut];
    } else {
        [self slideIn];
    }
}

- (void) slideOut {
    _itemIsAnimatingTransition = YES;
    
    _isSlidingIn = NO;
    _isSlidIn = NO;
}

- (void) slideIn {
    _menuItem.isVisible = YES;
    
    _itemIsAnimatingTransition = YES;
    
    _isSlidingIn = YES;
    _isSlidIn = YES;
}

- (void) step: (float) t delta: (float) dt { 
    if (_itemIsAnimatingTransition) {
        NVRect* rect = _menuItem.rect;
        
        float acceleration = _animationSpeed * dt;
        float slideMovement = _isSlidingIn ? acceleration : -acceleration;
        
        rect->x += _slideOutLeft ? slideMovement : -slideMovement;
        
        if (_slideOutLeft) {
            if ((!_isSlidingIn && rect->x + rect->width < 0) || 
                (_isSlidingIn && rect->x > _originX)) {
                if (_isSlidingIn) {
                    rect->x = _originX;
                } else {
                    rect->x = -rect->width;
                }
                
                _itemIsAnimatingTransition = NO;
            }
        } else {
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            
            if ((!_isSlidingIn && rect->x - rect->width > screenSize.width) || 
                (_isSlidingIn && rect->x + rect->width < screenSize.width)) {
                if (_isSlidingIn) {
                    rect->x = screenSize.width - rect->width;
                } else {
                    rect->x = screenSize.width;
                }
                
                _itemIsAnimatingTransition = NO;
            }            
        }
    }
}

- (void) didClick { }

- (BOOL) touchIntersectsMenuItem: (UITouch*) touch {
    CGPoint location = [touch locationInView: touch.view];
    
    CGFloat touchX = location.x;
    CGFloat touchY = touch.view.frame.size.height - location.y;
    
    NVRect* rect = _menuItem.rect;
    
    return (touchX >= rect->x && touchX <= rect->x + rect->width) &&
           (touchY >= rect->y && touchY <= rect->y + rect->height);
}

- (void) touchesBegan: (NSSet*) touches {
    if (_itemIsAnimatingTransition) {
        return;
    }
    
    if (!_itemTouch) {
        UITouch* anyTouch = [touches anyObject];
        
        if ([self touchIntersectsMenuItem: anyTouch]) {
            _itemTouch = anyTouch;
            
            _menuItem.rect->x -= 10;
        }
    }
}

- (void) touchesMoved: (NSSet*) touches {
    
}

- (void) touchesEnded: (NSSet*) touches {
    if (_itemIsAnimatingTransition) {
        return;
    }
    
    if (_itemTouch != nil) {    
        _menuItem.rect->x += 10;
        
        if ([self touchIntersectsMenuItem: _itemTouch]) {
            [[NVAudioCache sharedCache] playSoundWithKey: kAudioMenuTap gain: 1.0f pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
            
            [self didClick];
        }
        
        _itemTouch = nil;
    }
}

@end
