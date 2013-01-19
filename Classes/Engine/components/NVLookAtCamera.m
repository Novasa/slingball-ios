//
//  NVLookAtCamera.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/19/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVLookAtCamera.h"

@implementation NVLookAtCamera

@synthesize up = _up;
@synthesize target = _target;

- (id) init {
    if (self = [super init]) {
        _target = malloc(sizeof(kmVec3));
        _up = malloc(sizeof(kmVec3));
        
        kmVec3Zero(_target);
        kmVec3Fill(_up, 0, 1, 0);
    }
    return self;
}

- (void) start {
    [super start];
    
    _transform.delegate = self;
}

- (void) construct {
    [super construct];
    
    kmVec3 position = _transform.position;
    
    kmMat4LookAt(_view, &position, _target, _up);
    
    kmQuaternion localRotation = _transform.rotation;
    
    kmMat4 rotation;
    kmMat4RotationQuaternion(&rotation, &localRotation);
    
    kmMat4Multiply(_view, _view, &rotation);
}

- (void) transformationWasResolved: (NVTransformable*) transformable {
    [self construct];
}

- (void) dealloc {
    free(_target);
    free(_up);
    
    [super dealloc];
}

@end
