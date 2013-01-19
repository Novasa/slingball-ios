//
//  SBGoalController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/5/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBGoalController.h"

@implementation SBGoalController

@synthesize delegate = _delegate;

- (id) init {
    if (self = [super init]) {
        _strength = 0.94f;
 
        _hasCalculatedBounds = NO;
    }
    return self;
}

- (void) calculateBounds {
    if (_body.particleCount > 0) {
        NVSpringParticleAnchor* a = [_body particleAnchorAtIndex: 0];
        NVSpringParticleAnchor* b = [_body particleAnchorAtIndex: 1];
        
        float d = kmVec3DistanceSq(&a->position, &b->position);
        float r = d / 2;
        
        kmVec3 directionFromAToB;
        kmVec3Subtract(&directionFromAToB, &b->position, &a->position);
        kmVec3Normalize(&directionFromAToB, &directionFromAToB);
        
        kmVec3 center;
        kmVec3Add(&center, &a->position, kmVec3Scale(&center, &directionFromAToB, r));
        
        NVSphere bounds = {
            center, r
        };
        
        _bounds = bounds; 
        
        _hasCalculatedBounds = YES;
    }
}

- (void) step: (float) t delta: (float) dt {     
    if (_hasCalculatedBounds) {
        kmVec3 ballPosition = _ballCollider.position;
        
        float radii = _bounds.radius + _ballCollider.radius;
        
        BOOL ballIsWithinGoalHitbox = 
            fabs(_ballCollider.position.x - _bounds.center.x) < radii &&
            fabs(_ballCollider.position.y - _bounds.center.y) < radii &&
            fabs(_ballCollider.position.z - _bounds.center.z) < radii;
        
        if (ballIsWithinGoalHitbox) {
            for (int i = 1; i < _body.particleCount - 1; i++) {
                NVSpringParticle* particle = [_body particleAtIndex: i];
                
                if (point_is_in_sphere(&particle->position, &ballPosition, _ballCollider.radius)) {
                    if (![_delegate isWaitingToResetBall]) {
                        if (_delegate != nil) {
                            SEL callback = @selector(goalDidCatchBall:);
                            
                            if ([_delegate respondsToSelector: callback]){
                                [_delegate performSelector: callback withObject: self];
                            }
                        }
                    }
                    
                    kmVec3 directionFromBallToParticle;
                    kmVec3Normalize(&directionFromBallToParticle, kmVec3Subtract(&directionFromBallToParticle, &particle->position, &ballPosition));
                    
                    kmVec3 directionFromParticleToBall;
                    kmVec3Scale(&directionFromParticleToBall, &directionFromParticleToBall, -1);
                    
                    kmVec3 particlePositionAdjustment;
                    kmVec3Scale(&particlePositionAdjustment, &directionFromBallToParticle, _ballCollider.radius);
                    
                    kmVec3Add(&particle->position, &ballPosition, &particlePositionAdjustment);
                    
                    kmVec3Scale(_ballCollider.velocity, _ballCollider.velocity, _strength);
                }
            }
        }
    }
}

- (void) dealloc {
    if (_delegate != nil) {
        _delegate = nil;
    }
    
    [super dealloc];
}

@end
