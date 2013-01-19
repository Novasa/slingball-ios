//
//  SBFloatingGoalTextController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBFloatingTextController.h"

#import "NVCameraController.h"
#import "NVInterpolator.h"
#import "NVGame.h"

#import "SBGroups.h"

@implementation SBFloatingTextController

@synthesize alpha = _alpha;

@synthesize text = _text;

- (id) init {
    if (self = [super init]) {
        _alpha = 0;
        
        self.isEnabled = NO;
    }
    return self;
}

- (void) interpolatorDidStep: (NVInterpolator*) interpolator {
    kmVec3 interpolatedPosition;
    kmVec3Lerp(&interpolatedPosition, &_originalPosition, &_desiredPosition, interpolator.weight);
    
    _transform.position = interpolatedPosition;
    
    kmQuaternion interpolatedRotation;
    kmQuaternionSlerp(&interpolatedRotation, &_originalRotation, &_desiredRotation, interpolator.weight);
    
    _transform.rotation = interpolatedRotation;
    
    _alpha = interpolator.weight;
}

- (void) interpolatorDidFinish: (NVInterpolator*) interpolator {
    _interpolator = nil;
    
    self.isEnabled = NO;    
}

- (void) step: (float) t delta: (float) dt { 

}

- (void) displayFloatingText: (SBFloatingTextElement) floatingText forPlayerIndex: (NSUInteger) index {
    self.isEnabled = YES;
    
    _text = floatingText;
    
    _alpha = 0;
    
    NVTransformable* cameraTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: kGroupCamera];
    
    kmVec3Fill(&_originalPosition, 0, 0, 0.0f);
    
    _transform.position = _originalPosition;
 
    kmVec3 target = cameraTransform.position;
    kmVec3Fill(&_desiredPosition, target.x, target.y, target.z + 0.1f);
    
    kmVec3 rotationAxis;
    kmVec3Fill(&rotationAxis, 0, 0, 1);
        
    if (index == 1) {
        kmQuaternionIdentity(&_originalRotation);
        kmQuaternionRotationAxis(&_desiredRotation, &rotationAxis, kmDegreesToRadians(30));
    } else {
        kmQuaternionRotationAxis(&_originalRotation, &rotationAxis, kmDegreesToRadians(180.0f));
        kmQuaternionRotationAxis(&_desiredRotation, &rotationAxis, kmDegreesToRadians(210.0f));
    }   
    
    _transform.rotation = _originalRotation;

    if (_interpolator != nil) {
        [_interpolator end];
    }
    
    _interpolator = [[[NVGame sharedGame] scheduling] nextAvailableInterpolator];
    
    if (_interpolator != nil) {
        _interpolator.duration = 1.0f;
        
        if ([_interpolator beginWithDelegate: self]) {

        }
    }
}

@end
