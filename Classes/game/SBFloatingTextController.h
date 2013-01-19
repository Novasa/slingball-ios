//
//  SBFloatingGoalTextController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"
#import "NVInterpolator.h"
#import "NVInterpolatorDelegate.h"

typedef enum {
    SBFloatingTextElementGoal,
    SBFloatingTextElementOwnGoal,
    SBFloatingTextElementYouWin
} SBFloatingTextElement;

@interface SBFloatingTextController : NVSchedulable <NVInterpolatorDelegate> {
 @private
    REQUIRES(NVTransformable, _transform);
    
    kmVec3 _originalPosition;
    kmVec3 _desiredPosition;
    
    kmQuaternion _originalRotation;
    kmQuaternion _desiredRotation;
    
    float _alpha;
    
    SBFloatingTextElement _text;
    
    NVInterpolator* _interpolator;
}

@property(nonatomic, readonly) float alpha;

@property(nonatomic, readonly) SBFloatingTextElement text;

- (void) displayFloatingText: (SBFloatingTextElement) floatingText forPlayerIndex: (NSUInteger) index;

@end
