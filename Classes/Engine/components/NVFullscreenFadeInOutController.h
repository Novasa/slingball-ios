//
//  NVFullscreenFadeInOutController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVScreenSpacedRectangle.h"

@interface NVFullscreenFadeInOutController : NVSchedulable {
 @private
    REQUIRES(NVScreenSpacedRectangle, _screenSizedRectangle);
    
    BOOL _isAnimatingTransition;
    BOOL _isFadingIn;
    BOOL _isFadingInAndOut;
    
    float _timeStartedTransition;
    float _transitionDuration;
        
    float _initialAlpha;
    float _targetAlpha;
}

@property(nonatomic, readonly) BOOL isAnimatingTransition;

- (void) fadeInWithDuration: (float) duration;
- (void) fadeOutWithDuration: (float) duration;
- (void) fadeInAndOutWithDuration: (float) duration;

@end
