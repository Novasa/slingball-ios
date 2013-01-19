//
//  NVTransformable.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"
#import "NVTransformableDelegate.h"

@interface NVTransformable : NVComponent {
 @private
    // local data
    kmVec3* _position;
    kmVec3* _scale;
    kmQuaternion* _rotation;
    
    // resolution
    BOOL _requiresLocalResolution;
    BOOL _requiresWorldResolution;
    
    kmMat4* _local;
    kmMat4* _world;
    
    // parenting
    NVTransformable* _parent;
    
    BOOL _shouldInheritScale;
    BOOL _shouldInheritRotation;
    BOOL _shouldInheritTranslation;
    
    BOOL _invalidated;
    
    id<NVTransformableDelegate> _delegate;
}

@property(nonatomic, readwrite, assign) BOOL requiresLocalResolution; 
@property(nonatomic, readwrite, assign) BOOL requiresWorldResolution; 
@property(nonatomic, readwrite, assign) BOOL invalidated;

@property(nonatomic, readwrite, assign) kmVec3 position;
@property(nonatomic, readwrite, assign) kmVec3 scale;
@property(nonatomic, readwrite, assign) kmQuaternion rotation;

@property(nonatomic, readonly) kmMat4 local;
@property(nonatomic, readonly) kmMat4 world;

@property(nonatomic, readwrite, assign) NVTransformable* parent;

@property(nonatomic, readwrite, assign) id<NVTransformableDelegate> delegate;

@property(nonatomic, readwrite, assign) BOOL shouldInheritScale;
@property(nonatomic, readwrite, assign) BOOL shouldInheritRotation;
@property(nonatomic, readwrite, assign) BOOL shouldInheritTranslation;

@property(nonatomic, readonly) kmVec3 forward;
@property(nonatomic, readonly) kmVec3 backward;
@property(nonatomic, readonly) kmVec3 right;
@property(nonatomic, readonly) kmVec3 left;
@property(nonatomic, readonly) kmVec3 up;
@property(nonatomic, readonly) kmVec3 down;

- (void) resolve;

- (void) locallyRotateToFacePoint: (kmVec3*) point;
- (void) locallyRotateToFacePoint: (kmVec3*) point usingWorldUp: (kmVec3*) worldUp;

@end
