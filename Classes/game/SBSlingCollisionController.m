//
//  SBSlingCollisionController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingCollisionController.h"

#import "NVCameraController.h"
#import "NVAudioCache.h"

#import "SBGlobalAudioSource.h"

@implementation SBSlingCollisionController

- (void) checkCollisionAgainstBallAndSling {
    kmVec3* headPosition = _slingCollider.position;
    kmVec3* headVelocity = _slingCollider.velocity;
    
    kmVec3 ballPosition = _ballCollider.position;
    kmVec3* ballVelocity = _ballCollider.velocity;
    
    if (headPosition == NULL || headVelocity == NULL || ballVelocity == NULL) {
        return;
    }
    
    float ballRadius = _ballCollider.radius;
    float headRadius = _slingCollider.radius;
    
    float radii = ballRadius + headRadius;
    
    BOOL headIsWithinBallHitbox = 
        fabs(headPosition->x - ballPosition.x) < radii &&
        fabs(headPosition->y - ballPosition.y) < radii &&
        fabs(headPosition->z - ballPosition.z) < radii;
    
    if (headIsWithinBallHitbox) {
        float distance = kmVec3DistanceSq(headPosition, &ballPosition);
        
        if (distance < radii) {
            kmVec3 directionFromBallToHead;
            kmVec3Normalize(&directionFromBallToHead, kmVec3Subtract(&directionFromBallToHead, headPosition, &ballPosition));
            
            kmVec3 directionFromHeadToBall;
            kmVec3Scale(&directionFromHeadToBall, &directionFromBallToHead, -1);
            
            kmVec3 contactAdjustment;
            kmVec3Scale(&contactAdjustment, &directionFromBallToHead, ballRadius);
            
            kmVec3 contactPoint;
            kmVec3Add(&contactPoint, &ballPosition, &contactAdjustment);
            
            kmVec3 headPositionAdjustment;
            kmVec3Scale(&headPositionAdjustment, &directionFromBallToHead, radii);
            
            kmVec3Add(headPosition, &ballPosition, &headPositionAdjustment);
            
            kmVec3 reflectedHeadVelocity;
            kmVec3Reflect(&reflectedHeadVelocity, headVelocity, &directionFromBallToHead);
            //kmVec3Scale(&reflectedHeadVelocity, &reflectedHeadVelocity, 0.9f);
            
            kmVec3Assign(headVelocity, &reflectedHeadVelocity);
            
            float headForce = kmVec3LengthSq(headVelocity);
            
            kmVec3 addedBallVelocity;
            kmVec3Scale(&addedBallVelocity, &directionFromHeadToBall, headForce);
            
            kmVec3Add(ballVelocity, ballVelocity, &addedBallVelocity);
            
            _ballCollider.mostRecentCollider = _slingCollider;
            
            [self resolvedCollisionBetweenCollidable: _slingCollider 
                                       andCollidable: _ballCollider 
                                      atContactPoint: contactPoint];
    
            float gain = headForce * 10;
            
            if (gain > 1) {
                gain = 1;
            }
            
            [[NVAudioCache sharedCache] playSoundWithKey: kAudioSlingCollision gain: gain pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
        }
    }
}

- (void) checkCollisionAgainstSlingAndBoundaries {
    kmVec3* position = _slingCollider.position;
    kmVec3* velocity = _slingCollider.velocity;

    if (position == NULL || velocity == NULL) {
        return;
    }
    
    float r = _slingCollider.radius;
    
    float d = _playingFieldController.width / 2;
    float w = _playingFieldController.height / 2;

    kmVec3 min;
    kmVec3Fill(&min, -d, -w, 0);
    
    kmVec3 max;
    kmVec3Fill(&max, d, w, 0);
    
    NVAABB bounds = {
        min, max
    };
    
    SBCollisionWall result = [SBCollisionController innerWallCollisionForSphereWithCenter: position 
                                                                                andRadius: r 
                                                                        againstBoundaries: bounds];
    
    kmVec3 reflectionPlane;
    kmVec3 contactPoint;
    
    if ((result & SBCollisionWallLeft) != 0) {
        position->x = min.x + r;
        
        kmVec3Fill(&reflectionPlane, 1, 0, 0);
        kmVec3Fill(&contactPoint, min.x, position->y, position->z);
    } else if ((result & SBCollisionWallRight) != 0) {
        position->x = max.x - r;
        
        kmVec3Fill(&reflectionPlane, -1, 0, 0);
        kmVec3Fill(&contactPoint, max.x, position->y, position->z);
    } 
    
    if ((result & SBCollisionWallDown) != 0) {
        position->y = min.y + r;
        
        kmVec3Fill(&reflectionPlane, 0, -1, 0);
        kmVec3Fill(&contactPoint, position->x, min.y, position->z);
    } else if ((result & SBCollisionWallUp) != 0) {
        position->y = max.y - r;
        
        kmVec3Fill(&reflectionPlane, 0, 1, 0);
        kmVec3Fill(&contactPoint, position->x, max.y, position->z);
    }
    
    if (result != SBCollisionWallNone) {
        float l = kmVec3LengthSq(velocity);
        
        if (l > kmEpsilon) {
            float gain = l * 25;
            
            if (gain < 0.1f) {
                gain = 0.1f;
            } else if (gain > 1) {
                gain = 1;
            }
            
            [[NVAudioCache sharedCache] playSoundWithKey: kAudioWallCollision gain: gain pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
            
            kmVec3Reflect(velocity, velocity, &reflectionPlane);
            
            [self resolvedCollisionAtContactPoint: contactPoint];
        }
    }
    
    position->z = 0;
}

- (void) resolve {
    [self checkCollisionAgainstBallAndSling];
    [self checkCollisionAgainstSlingAndBoundaries];
}

@end
