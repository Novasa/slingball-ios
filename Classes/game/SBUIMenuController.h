//
//  SBUIMenuController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVScreenSpacedRectangle.h"
#import "NVSchedulable.h"
#import "NVTouchable.h"

@interface SBUIMenuController : NVSchedulable <NVTouchable> {
 @private
    REQUIRES(NVScreenSpacedRectangle, _menuItem);
    
    UITouch* _itemTouch;
    
    BOOL _itemIsAnimatingTransition;
    
    BOOL _isSlidingIn;
    BOOL _isSlidIn;
    
    BOOL _slideOutLeft;
    
    float _animationSpeed;
    float _originX;
}

@property(nonatomic, readwrite, assign) BOOL slideOutLeft;
@property(nonatomic, readonly) BOOL isSlidIn;

- (void) slideOut;
- (void) slideIn;
- (void) toggleSlideInOut;

- (void) didClick;

@end
