//
//  NVDraggableArcBall.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVDraggableArcBall.h"

@implementation NVDraggableArcBall

@synthesize isAcceptingInput = _isAcceptingInput;

- (id) init {
    if (self = [super init]) {
        _startPoint = CGPointMake(0, 0);
        
        _startVector = malloc(sizeof(kmVec3));
        _startRotation = malloc(sizeof(kmQuaternion));
        _velocityAxis = malloc(sizeof(kmVec3));
        
        kmVec3Fill(_startVector, 0, 0, 1);
        kmVec3Zero(_velocityAxis);
        
        kmQuaternionIdentity(_startRotation);
        
        _velocity = 0;
        _velocityFriction = 0.93f;
        _velocityLimiter = 0.35f;
        _velocityMax = 25;
        
        _isAcceptingInput = YES;
        _shouldApplyScrolling = NO;
        
        _previousTouchState = [[NVTouchBuffer sharedBuffer] state];
    }
    return self;
}

- (void) step: (float) t delta: (float) dt { 
    if (_shouldApplyScrolling) {
        kmQuaternion delta;
        kmQuaternionRotationAxis(&delta, _velocityAxis, kmDegreesToRadians(_velocity));
        kmQuaternionNormalize(&delta, &delta);
        
        kmQuaternion current = _transform.rotation;
        kmQuaternion tmp;
        
        kmQuaternionMultiply(&tmp, &delta, &current);
        kmQuaternionNormalize(&tmp, &tmp);
        
        _transform.rotation = tmp;
    }
    
    if (_velocity > kmEpsilon) {
        _velocity *= _velocityFriction;
    } else if (_velocity <= kmEpsilon) {
        _velocity = 0;
        
        _shouldApplyScrolling = NO;
    }
}

- (void) update: (float) elapsed interpolation: (float) alpha {
    NVTouchState currentTouchState = [[NVTouchBuffer sharedBuffer] state];
    
    if (_isAcceptingInput) {
        if (currentTouchState.pressed && !_previousTouchState.pressed) {
            _shouldApplyScrolling = NO;
            
            _startedTouching = current_time();
            _startPoint = CGPointMake(currentTouchState.x, currentTouchState.y);
            
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            
            screen_to_unitsphere(_startVector, _startPoint.x, _startPoint.y, screenSize.width, screenSize.height);
            
            kmQuaternion current = _transform.rotation;
            
            kmQuaternionAssign(_startRotation, &current);
        } else if (!currentTouchState.pressed && _previousTouchState.pressed) {
            _shouldApplyScrolling = YES;
            
            float timeBetweenTouchdownAndNow = current_time() - _startedTouching;
            
            float dx = _previousTouchState.x - _startPoint.x;
            float dy = _previousTouchState.y - _startPoint.y;
            
            float distance = (sqrtf((dx * dx) + (dy * dy))) / timeBetweenTouchdownAndNow;
            
            float timeToScroll = (distance / 980) * _velocityLimiter;
            float distanceToScroll = ((distance * distance) / (2 * 980)) * _velocityLimiter;
            
            _velocity += distanceToScroll * timeToScroll;
            
            if (_velocity > _velocityMax) {
                _velocity = _velocityMax;
            }
        } else if (currentTouchState.pressed) {
            if (currentTouchState.x != _previousTouchState.x || currentTouchState.y != _previousTouchState.y) {
                kmVec3 currentVector;
                
                CGSize screenSize = [UIScreen mainScreen].bounds.size;
                
                screen_to_unitsphere(&currentVector, currentTouchState.x, currentTouchState.y, screenSize.width, screenSize.height);
                //screen_to_unitsphere(&currentVector, lerp(_previousTouchState.x, currentTouchState.x, 1 - alpha), lerp(_previousTouchState.y, currentTouchState.y, 1 - alpha), IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
                
                kmVec3 axis;
                kmVec3Cross(&axis, _startVector, &currentVector);
                kmVec3Normalize(&axis, &axis);    
                
                GLfloat theta = acosf(kmVec3Dot(_startVector, &currentVector));
                
                kmQuaternion delta;
                kmQuaternionRotationAxis(&delta, &axis, theta);
                kmQuaternionNormalize(&delta, &delta);
                
                // NOTE: order of multiplication here is extremely important --
                // start * delta != delta * start
                // the wrong order will cause deterioration in the final rotation
                kmQuaternion newRotation;
                kmQuaternionMultiply(&newRotation, &delta, _startRotation);
                kmQuaternionNormalize(&newRotation, &newRotation);
                
                _transform.rotation = newRotation;
                /*
                // NOTE: the slerping can be removed for a snappier feel, simply assign newRotation directly to _transform.rotation
                kmQuaternion tmp;
                kmQuaternionSlerp(&tmp, &tmp, &newRotation, 1 - alpha);
                kmQuaternionNormalize(&tmp, &tmp);
                
                _transform.rotation = tmp;
                */
                kmVec3Assign(_velocityAxis, &axis);
            }
        }
    }
    
    _previousTouchState = currentTouchState;
}

- (void) dealloc {
    free(_startVector);   
    free(_startRotation);
    
    free(_velocityAxis);
    
    [super dealloc];
}

@end
