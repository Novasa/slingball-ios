//
//  SBBallExplosionParticlesController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/24/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBallExplosionParticlesController.h"

@implementation SBBallExplosionParticlesController

- (id) init {
    if (self = [super init]) {
        _gravity = malloc(sizeof(kmVec3));
        
        kmVec3Fill(_gravity, 0, 0, -0.1f);
        
        _hasAllocatedMemory = NO;
        
        self.isEnabled = NO;
    }
    return self;
}

- (void) start {
    [super start];
    
    [self reset];
}

- (void) resetParticle: (SBBallExplosionParticle*) particle {
    particle->life = 1.0f;
    particle->decay = random_float() + 0.2f;
    
    kmVec3 origin = _transform.position;
    kmVec3Assign(&particle->position, &origin);
    
    kmVec3 velocity;
    assign_random_orbital_axis(&velocity);
    
    if (velocity.z < 0) {
        velocity.z = -velocity.z;
    }
    
    velocity.z *= 5;
    
    float speed = random_float() + 0.25f;
    
    kmVec3Scale(&particle->velocity, &velocity, speed);    
}

- (void) reset {
    for (int i = 0; i < kMaxBallExplosionParticles; i++) {
        if (!_hasAllocatedMemory) {
            _particles[i] = malloc(sizeof(SBBallExplosionParticle));
        }
        
        SBBallExplosionParticle* particle = _particles[i];
        
        [self resetParticle: particle];
    }    
    
    if (!_hasAllocatedMemory) {
        _hasAllocatedMemory = YES;
    }
}

- (SBBallExplosionParticle*) particleAtIndex: (NSUInteger) index {
    if (index < kMaxBallExplosionParticles) {
        return _particles[index];
    }
    
    return NULL;
}
/*
- (SBBallExplosionParticle*) allParticles {
    return _particles;
}
*/
- (void) step: (float) t delta: (float) dt { 
    BOOL isEmittingParticles = NO;
    
    for (int i = 0; i < kMaxBallExplosionParticles; i++) {
        SBBallExplosionParticle* particle = _particles[i];
        
        if (particle->life > 0) {
            particle->life -= particle->decay * dt;
            
            kmVec3 velocity;
            kmVec3Scale(&velocity, &particle->velocity, dt);
            
            kmVec3Add(&particle->position, &particle->position, &velocity);
            kmVec3Add(&particle->velocity, &particle->velocity, _gravity);
            
            if (particle->position.z < 0) {
                particle->position.z = 0;
                
                kmVec3Scale(&particle->velocity, &particle->velocity, 0.75f);
                
                particle->velocity.z = -particle->velocity.z;
            }
            
            isEmittingParticles = YES;
        }
    }
    
    if (!isEmittingParticles) {
        self.isEnabled = NO;
    }
}

- (void) dealloc {
    free(_gravity);
    
    if (_hasAllocatedMemory) {
        for (int i = 0; i < kMaxBallExplosionParticles; i++) {
            SBBallExplosionParticle* particle = _particles[i];
            
            free(particle);
        }    
    }
    
    [super dealloc];
}

@end
