//
//  SBSlingSlingCollisionController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/12/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingSlingCollisionController.h"

#import "NVAudioCache.h"

#import "SBGlobalAudioSource.h"

@implementation SBSlingSlingCollisionController

- (void) checkCollisionAgainstSlingAndSling {
    kmVec3* ap = _playerOneHead.position;
    kmVec3* av = _playerOneHead.velocity;

    kmVec3* bp = _playerTwoHead.position;
    kmVec3* bv = _playerTwoHead.velocity;
    
    if (ap == NULL || av == NULL || bp == NULL || bv == NULL) {
        return;
    }
    
    float ar = _playerOneHead.radius;
    float br = _playerTwoHead.radius;
    
    float radii = ar + br;
    
    BOOL aIsWithinBHitbox = 
        fabs(ap->x - bp->x) < radii &&
        fabs(ap->y - bp->y) < radii &&
        fabs(ap->z - bp->z) < radii;
    
    if (aIsWithinBHitbox) {
        float distance = kmVec3DistanceSq(ap, bp);
        
        if (distance < radii) {
            float al = kmVec3LengthSq(av);
            float bl = kmVec3LengthSq(bv);
            
            kmVec3 directionFromAToB;
            kmVec3Normalize(&directionFromAToB, kmVec3Subtract(&directionFromAToB, bp, ap));
            
            kmVec3 directionFromBToA;
            kmVec3Scale(&directionFromBToA, &directionFromAToB, -1);
            
            if (bl > al) {
                float adjustmentDistance = br;
                
                kmVec3 contactAdjustment;
                kmVec3Scale(&contactAdjustment, &directionFromAToB, adjustmentDistance);
                
                kmVec3 contactPoint;
                kmVec3Add(&contactPoint, ap, &contactAdjustment);
                
                kmVec3 headPositionAdjustment;
                kmVec3Scale(&headPositionAdjustment, &directionFromAToB, radii);
                
                kmVec3Add(bp, ap, &headPositionAdjustment);
            } else {
                float adjustmentDistance = ar;
                
                kmVec3 contactAdjustment;
                kmVec3Scale(&contactAdjustment, &directionFromBToA, adjustmentDistance);
                
                kmVec3 contactPoint;
                kmVec3Add(&contactPoint, bp, &contactAdjustment);
                
                kmVec3 headPositionAdjustment;
                kmVec3Scale(&headPositionAdjustment, &directionFromBToA, radii);
                
                kmVec3Add(ap, bp, &headPositionAdjustment);
            }
            
            if (al > kmEpsilon || bl > kmEpsilon) {            
                if (bl > kmEpsilon) {
                    kmVec3 addedAVelocity;
                    kmVec3Scale(&addedAVelocity, &directionFromBToA, bl);
                    
                    kmVec3Add(av, av, &addedAVelocity);
                }
                
                if (al > kmEpsilon) {
                    kmVec3 addedBVelocity;
                    kmVec3Scale(&addedBVelocity, &directionFromAToB, al);
                    
                    kmVec3Add(bv, bv, &addedBVelocity);
                }

                [[NVAudioCache sharedCache] playSoundWithKey: kAudioSlingCollision gain: al + bl pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
            }
        }
    }
}

- (void) step: (float) t delta: (float) dt { 
    [self checkCollisionAgainstSlingAndSling];
}

@end
