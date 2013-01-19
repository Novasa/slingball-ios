//
//  SBBallController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBallController.h"
#import "SBCollisionController.h"
#import "SBGlobalAudioSource.h"

#import "NVAudioCache.h"

@implementation SBBallController

@synthesize velocity = _velocity;

- (id) init {
    if (self = [super init]) {
        _velocity = malloc(sizeof(kmVec3));
        
        kmVec3Zero(_velocity);
    }
    return self;
}

- (void) applyRoll {
    float speed = kmVec3Length(_velocity);
    float theta = (speed / _transform.scale.x) * 100;
    
    kmVec3 direction;
    kmVec3Normalize(&direction, _velocity);
    
    kmVec3 up;
    kmVec3Fill(&up, 0, 0, 1);
    
    kmVec3 rotationAxis;
    kmVec3Cross(&rotationAxis, &direction, &up);
    
    kmQuaternion newRotation;
    kmQuaternionRotationAxis(&newRotation, &rotationAxis, theta);
    
    kmQuaternion currentRotation = _transform.rotation;
    
    kmQuaternionAdd(&newRotation, &currentRotation, &newRotation);
    kmQuaternionNormalize(&newRotation, &newRotation);
    
    _transform.rotation = newRotation;   
}

- (void) step: (float) t delta: (float) dt { 
    kmVec3 position = _transform.position;
    
    float l = kmVec3LengthSq(_velocity);
    float max = 0.35f;
    
    if (l > max) {
        kmVec3Scale(_velocity, _velocity, max / l);
    }
    
    kmVec3Add(&position, &position, _velocity);
    kmVec3Scale(_velocity, _velocity, _playingFieldController.friction);
    
    float d = _playingFieldController.width / 2;
    float w = _playingFieldController.height / 2;
    
    float r = _transform.scale.x;

    float gd = _playingFieldController.goalWidth / 2;
    
    if (position.x > -gd && position.x < gd) {
        
    } else {
        kmVec3 min;
        kmVec3Fill(&min, -d, -w, 0);
        
        kmVec3 max;
        kmVec3Fill(&max, d, w, 0);

        NVAABB bounds = {
            min, max
        };
        /*
        if (position.x + r < min.x) {
            kmVec3 negatedVelocity;
            kmVec3Scale(&negatedVelocity, &negatedVelocity, -1);
            
            kmVec3 direction;
            kmVec3Normalize(&direction, &negatedVelocity);
            
            NVRay ray = NVRayMake(position.x, position.y, position.z, direction.x, direction.y, direction.z);
            NVPlane plane = NVPlaneMake(min.x, 0, 0, -1, 0, 0);
            
            kmVec3 intersection;
            
            ray_plane_intersection(&intersection, &ray, &plane);
            
            kmVec3 positionAdjustment;
            kmVec3Scale(&positionAdjustment, &direction, r * 2);
            
            kmVec3Add(&position, &intersection, &positionAdjustment);
        
            kmVec3 reflectionPlane;
            kmVec3Fill(&reflectionPlane, 1, 0, 0);
            kmVec3Reflect(_velocity, _velocity, &reflectionPlane);
        }
        */
        SBCollisionWall result = [SBCollisionController innerWallCollisionForSphereWithCenter: &position andRadius: r againstBoundaries: bounds];
        
        kmVec3 reflectionPlane;

        if ((result & SBCollisionWallLeft) != 0) {
            position.x = min.x + r;
            
            kmVec3Fill(&reflectionPlane, 1, 0, 0);
        } else if ((result & SBCollisionWallRight) != 0) {
            position.x = max.x - r;
            
            kmVec3Fill(&reflectionPlane, -1, 0, 0);
        } 
        
        if ((result & SBCollisionWallDown) != 0) {
            position.y = min.y + r;
            
            kmVec3Fill(&reflectionPlane, 0, -1, 0);
        } else if ((result & SBCollisionWallUp) != 0) {
            position.y = max.y - r;
            
            kmVec3Fill(&reflectionPlane, 0, 1, 0);
        }
        
        if (result != SBCollisionWallNone) {
            if (l > kmEpsilon) {            
                float gain = l * 25;
                
                if (gain < 0.1f) {
                    gain = 0.1f;
                } else if (gain > 1) {
                    gain = 1;
                }
                
                [[NVAudioCache sharedCache] playSoundWithKey: kAudioWallCollision gain: gain pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
                
                kmVec3Reflect(_velocity, _velocity, &reflectionPlane);
            }
        }
    }
    
    position.z = 0;

    _transform.position = position;
    
    [self applyRoll];
}

- (void) reset {
    kmVec3 origin;
    kmVec3Zero(&origin);
    
    kmQuaternion identity;
    kmQuaternionIdentity(&identity);
    
    _transform.position = origin;
    _transform.rotation = identity;
    
    kmVec3Zero(_velocity);
}

- (void) dealloc {
    free(_velocity);
    
    [super dealloc];
}

@end
