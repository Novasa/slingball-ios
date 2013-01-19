//
//  SBBallTrailController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/8/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBallTrailController.h"

@implementation SBBallTrailController

- (id) init {
    if (self = [super init]) {
        _hasAllocatedMemory = NO;
        
        _timeElapsedSincePreviousSpawn = 0;
        _spawnInterval = FIXED_TIME_STEP;
        
        self.isEnabled = YES;
    }
    return self;
}

- (void) start {
    [super start];
    
    [self reset];
}

- (void) resetParticle: (SBBallTrailParticle*) particle {
    particle->life = 1.0;
    
    kmVec3 ballPosition = _transform.position;
    
    kmVec3 velocity;
    kmVec3Scale(&velocity, _ballController.velocity, -1);

    float l = kmVec3LengthSq(&velocity);
    float max = 0.1f;
    
    if (l > max) {
        kmVec3Scale(&velocity, &velocity, max / l);
    }
    
    kmVec3 direction;
    kmVec3Normalize(&direction, &velocity);
    
    kmVec3 positionAdjustment;
    kmVec3Scale(&positionAdjustment, &direction, _ballCollider.radius);

    float angleSpread = 100;
    float angle = kmDegreesToRadians(angleSpread * random_float());

    angle = rand() % 2 > 0 ? angle : -angle;

    kmMat4 velocityRotation;
    kmMat4RotationZ(&velocityRotation, angle);
    
    kmVec3Transform(&velocity, &velocity, &velocityRotation);
    
    kmVec3Add(&particle->position, &ballPosition, &positionAdjustment);
    kmVec3Assign(&particle->velocity, &velocity);
}

- (void) reset {
    for (int i = 0; i < kMaxBallTrailParticles; i++) {
        if (!_hasAllocatedMemory) {
            _particles[i] = malloc(sizeof(SBBallTrailParticle));
        }
        
        SBBallTrailParticle* particle = _particles[i];
        
        [self resetParticle: particle];
    }    
    
    if (!_hasAllocatedMemory) {
        _hasAllocatedMemory = YES;
    }
}

- (SBBallTrailParticle*) particleAtIndex: (NSUInteger) index {
    if (index < kMaxBallTrailParticles) {
        return _particles[index];
    }
    
    return NULL;
}

- (void) step: (float) t delta: (float) dt { 
    BOOL isEmittingParticles = NO;
    
    float decay = 3.75f;
    
    _timeElapsedSincePreviousSpawn += dt;
    
    for (int i = 0; i < kMaxBallTrailParticles; i++) {
        SBBallTrailParticle* particle = _particles[i];
        
        if (particle->life > 0) {
            particle->life -= decay * dt;
            
            kmVec3Add(&particle->position, &particle->position, &particle->velocity);
            
            isEmittingParticles = YES;
        } else {
            if (_timeElapsedSincePreviousSpawn >= _spawnInterval && kmVec3LengthSq(_ballController.velocity) > kmEpsilon) {
                _timeElapsedSincePreviousSpawn = 0;
                
                [self resetParticle: particle];
            }
        }
    }
}

- (void) dealloc {
    if (_hasAllocatedMemory) {
        for (int i = 0; i < kMaxBallTrailParticles; i++) {
            SBBallTrailParticle* particle = _particles[i];
            
            free(particle);
        }    
    }
    
    [super dealloc];
}

@end
