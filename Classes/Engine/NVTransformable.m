//
//  NVTransformable.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVTransformable.h"

@implementation NVTransformable

- (id) init {
    if (self = [super init]) {
        _position = malloc(sizeof(kmVec3));
        _scale = malloc(sizeof(kmVec3));
        
        kmVec3Zero(_position);
        kmVec3Fill(_scale, 1, 1, 1);
        
        _rotation = malloc(sizeof(kmQuaternion));
        
        kmQuaternionIdentity(_rotation);
        
        _shouldInheritScale = YES;
        _shouldInheritRotation = YES;
        _shouldInheritTranslation = YES;
        
        _local = malloc(sizeof(kmMat4));
        _world = malloc(sizeof(kmMat4));
        
        _requiresLocalResolution = YES;
        _requiresWorldResolution = YES;
        
        _invalidated = NO;
    }
    return self;
}

@synthesize requiresLocalResolution = _requiresLocalResolution;
@synthesize requiresWorldResolution = _requiresWorldResolution;
@synthesize invalidated = _invalidated;

@dynamic position;
@dynamic scale;
@dynamic rotation;

@dynamic parent;

@synthesize delegate = _delegate;

@dynamic shouldInheritTranslation;
@dynamic shouldInheritRotation;
@dynamic shouldInheritScale;

@dynamic local;
@dynamic world;

- (void) resolve {
    _invalidated = NO;
    
    BOOL requiresWorldResolution = _requiresWorldResolution;
    
    if (!requiresWorldResolution) {
        // figure out if any parent has invalidated their transforms
        NVTransformable* parent = _parent;
        
        while (parent != nil) {
            if (parent.invalidated) {
                requiresWorldResolution = YES;

                break;
            }
            
            parent = parent.parent;
        }
    }
    
    if (_requiresLocalResolution) {
        //NSLog(@"resolving local transformation for: %@", self.group);
        
        kmMat4 translation;
        kmMat4 rotation;
        kmMat4 scaling;
        
        kmMat4Translation(&translation, _position->x, _position->y, _position->z);
        kmMat4RotationQuaternion(&rotation, _rotation);
        kmMat4Scaling(&scaling, _scale->x, _scale->y, _scale->z);
        
        kmMat4Identity(_local);
        kmMat4Multiply(_local, &translation, &rotation);
        kmMat4Multiply(_local, _local, &scaling);
        
        _requiresLocalResolution = NO;
        requiresWorldResolution = YES;
    }
    
    if (requiresWorldResolution) {
        //NSLog(@"resolving world transformation for: %@", self.group);
        
        kmMat4 parentWorld;
        kmMat4Identity(&parentWorld);
        
        if (_parent != nil) {
            BOOL parentWasInvalidated = _parent.invalidated;
            
            [_parent resolve];
            
            _parent.invalidated = parentWasInvalidated;
            
            parentWorld = _parent.world;
        }
        
        kmMat4Identity(_world);
        kmMat4Multiply(_world, &parentWorld, _local);
        
        _requiresWorldResolution = NO;
        
        _invalidated = YES;
        
        if (_delegate != nil) {
            SEL transformationWasResolved = @selector(transformationWasResolved:);
            
            if ([_delegate respondsToSelector: transformationWasResolved]) {
                [_delegate performSelector: transformationWasResolved withObject: self];
            }
        }
    }
}

- (void) locallyRotateToFacePoint: (kmVec3*) point {
    kmVec3 worldUp;
    kmVec3Fill(&worldUp, 0, 1, 0);
    
    [self locallyRotateToFacePoint: point usingWorldUp: &worldUp];
}

- (void) locallyRotateToFacePoint: (kmVec3*) point usingWorldUp: (kmVec3*) worldUp {
    kmVec3 up;
    kmVec3 right;
    kmVec3 left;
    kmVec3 forward;
    
    kmVec3Normalize(&forward, kmVec3Subtract(&forward, point, _position));
    kmVec3Normalize(&right, kmVec3Cross(&right, &forward, worldUp));
    
    if (fabsf(right.x) <= kmEpsilon &&
        fabsf(right.y) <= kmEpsilon &&
        fabsf(right.z) <= kmEpsilon) {
        kmVec3Fill(&right, 1, 0, 0);
    }
    
    kmVec3Fill(&left, -right.x, -right.y, -right.z);
    
    kmVec3Normalize(&up, kmVec3Cross(&up, &forward, &left));
    
    kmMat4 orientation;
    kmMat4Identity(&orientation);
    
    orientation.mat[0] = left.x;
    orientation.mat[1] = left.y;
    orientation.mat[2] = left.z;
    
    orientation.mat[4] = up.x;
    orientation.mat[5] = up.y;
    orientation.mat[6] = up.z;
    
    orientation.mat[8] = forward.x;
    orientation.mat[9] = forward.y;
    orientation.mat[10] = forward.z;
    
    kmMat3 rotationMatrix;
    kmMat4ExtractRotation(&rotationMatrix, &orientation);
    
    kmQuaternion rotation;
    kmQuaternionRotationMatrix(&rotation, &rotationMatrix);
    kmQuaternionNormalize(&rotation, &rotation);
    
    self.rotation = rotation;
}

- (BOOL) shouldInheritTranslation {
    return _shouldInheritTranslation;
}

- (void) setShouldInheritTranslation: (BOOL) inheritTranslation {
    if (_shouldInheritTranslation != inheritTranslation) {
        _shouldInheritTranslation = inheritTranslation;
        
        _requiresWorldResolution = YES;
    }
}

- (BOOL) shouldInheritRotation {
    return _shouldInheritRotation;
}

- (void) setShouldInheritRotation: (BOOL) inheritRotation {
    if (_shouldInheritRotation != inheritRotation) {
        _shouldInheritRotation = inheritRotation;
        
        _requiresWorldResolution = YES;
    }
}

- (BOOL) shouldInheritScale {
    return _shouldInheritScale;
}

- (void) setShouldInheritScale: (BOOL) inheritScale {
    if (_shouldInheritScale != inheritScale) {
        _shouldInheritScale = inheritScale;
        
        _requiresWorldResolution = YES;
    }
}

- (kmVec3) position {
    kmVec3 position;
    
    kmVec3Assign(&position, _position);
    
    return position;
}

- (void) setPosition: (kmVec3) position {
    //if (!kmVec3AreEqual(_position, &position)) {
        kmVec3Assign(_position, &position);
        
        _requiresLocalResolution = YES;
    //}
}

- (kmVec3) scale {
    kmVec3 scale;
    
    kmVec3Assign(&scale, _scale);
    
    return scale;
}

- (void) setScale: (kmVec3) scale {
    //if (!kmVec3AreEqual(_scale, &scale)) {
        kmVec3Assign(_scale, &scale);
        
        _requiresLocalResolution = YES;
    //}
}

- (kmQuaternion) rotation {
    kmQuaternion rotation;
    
    kmQuaternionAssign(&rotation, _rotation);
    
    return rotation;
}

- (void) setRotation: (kmQuaternion) rotation {
    //if (!kmQuaternionAreEqual(_rotation, &rotation)) {
        kmQuaternionAssign(_rotation, &rotation);
        
        _requiresLocalResolution = YES;
    //}
}

- (NVTransformable*) parent {
    return _parent;
}

- (void) setParent: (NVTransformable*) parent {
    if (_parent != parent) {
        _parent = parent;
        
        _requiresLocalResolution = YES;
    }
}

- (kmMat4) local {
    kmMat4 local;
    
    kmMat4Assign(&local, _local);
    
    return local;
}

- (kmMat4) world {
    kmMat4 world;
    
    kmMat4Assign(&world, _world);
    
    return world;
}

- (kmVec3) forward {
    kmVec3 forward;
    kmMat4GetForwardVec3(&forward, _world);
    
    return forward;
}

- (kmVec3) backward {
    kmVec3 forward = [self forward];
    
    kmVec3 backward;
    kmVec3Scale(&backward, &forward, -1);
    
    return backward;
}

- (kmVec3) right {
    kmVec3 right;
    kmMat4GetRightVec3(&right, _world);
    
    return right;
}

- (kmVec3) left {
    kmVec3 right = [self right];
    
    kmVec3 left;
    kmVec3Scale(&left, &right, -1);
    
    return left;
}

- (kmVec3) up {
    kmVec3 up;
    kmMat4GetUpVec3(&up, _world);
    
    return up;
}

- (kmVec3) down {
    kmVec3 up = [self up];
    
    kmVec3 down;
    kmVec3Scale(&down, &up, -1);
    
    return down;
}

- (void) dealloc {
    free(_position);
    free(_scale);
    free(_rotation);
    
    free(_local);
    free(_world);
    
    [super dealloc];
}

@end
