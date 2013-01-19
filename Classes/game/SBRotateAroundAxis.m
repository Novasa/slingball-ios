//
//  SBRotateAroundAxis.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/26/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBRotateAroundAxis.h"

@implementation SBRotateAroundAxis

@synthesize axis = _axis;
@synthesize speed = _speed;

- (id) init {
    if (self = [super init]) {
        _axis = malloc(sizeof(kmVec3));
        
        kmVec3Fill(_axis, 0, 1, 0);
        
        _speed = 1;
        _angle = 0;
    }
    return self;
}

- (void) step: (float) t delta: (float) dt { 
    _angle += _speed * dt;

    if (_angle > 360.0f) {
        _angle = 0;
    }
    
    kmQuaternion newRotation;
    kmQuaternionRotationAxis(&newRotation, _axis, _angle);
    
    kmQuaternion currentRotation = _transform.rotation;
    
    kmQuaternionAdd(&newRotation, &currentRotation, &newRotation);
    kmQuaternionNormalize(&newRotation, &newRotation);
    
    _transform.rotation = newRotation;
}

- (void) didChangeEnability {
    [super didChangeEnability];
    
    _angle = 0;
}

- (void) dealloc {
    free(_axis);
    
    [super dealloc];
}

@end
