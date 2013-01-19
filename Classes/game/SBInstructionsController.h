//
//  SBInstructionsController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/26/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"
#import "NVInterpolatorDelegate.h"

@interface SBInstructionsController : NVComponent <NVInterpolatorDelegate> {
 @private
    float _alpha;
    
    BOOL _hasFadedOutOnce;
    
    BOOL _isFadingIn;
    BOOL _isFadingOut;
}

@property(nonatomic, readonly) float alpha;

- (void) fadeIn;
- (void) fadeOut;

@end
