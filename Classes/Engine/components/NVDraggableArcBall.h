//
//  NVDraggableArcBall.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"
#import "NVTouchBuffer.h"

@interface NVDraggableArcBall : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    BOOL _isAcceptingInput;
    BOOL _shouldApplyScrolling;
    
    CGPoint _startPoint;
    
    kmVec3* _startVector;
    kmVec3* _velocityAxis;
    
    kmQuaternion* _startRotation;
    
    float _velocity;
    float _velocityFriction;
    float _velocityMax;
    float _velocityLimiter;
    
    float _startedTouching;
    
    NVTouchState _previousTouchState;
}

@property(nonatomic, readwrite, assign) BOOL isAcceptingInput;

@end
