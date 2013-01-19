//
//  SBCollisionParticlesController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/3/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBCollisionParticlesController.h"

@implementation SBCollisionParticlesController

- (id) init {
    if (self = [super init]) {
        _hasAllocatedMemory = NO;
            
        self.isEnabled = NO;
    }
    return self;
}

- (void) start {
    [super start];
    
    [self reset];
}

- (void) resetParticle: (SBCollisionParticle*) particle {
    particle->life = 1.0f;
    particle->decay = 1.0f + (random_float() * 10);

    kmVec3 origin;
    kmVec3Zero(&origin);
    kmVec3Assign(&particle->position, &origin);
    
    kmVec3 velocity;
    assign_random_orbital_axis(&velocity);

    float speed = random_float() * 0.085f;
    
    kmVec3Scale(&particle->velocity, &velocity, speed);    
}

- (void) reset {
    for (int i = 0; i < kMaxCollisionParticles; i++) {
        if (!_hasAllocatedMemory) {
            _particles[i] = malloc(sizeof(SBCollisionParticle));
        }
        
        SBCollisionParticle* particle = _particles[i];
        
        [self resetParticle: particle];
    }    
    
    if (!_hasAllocatedMemory) {
        _hasAllocatedMemory = YES;
    }
}

- (SBCollisionParticle*) particleAtIndex: (NSUInteger) index {
    if (index < kMaxCollisionParticles) {
        return _particles[index];
    }
    
    return NULL;
}

- (void) step: (float) t delta: (float) dt { 
    BOOL isEmittingParticles = NO;
    
    for (int i = 0; i < kMaxCollisionParticles; i++) {
        SBCollisionParticle* particle = _particles[i];
        
        if (particle->life > 0) {
            particle->life -= particle->decay * dt;
            
            kmVec3Add(&particle->position, &particle->position, &particle->velocity);
            
            isEmittingParticles = YES;
        }
    }
    
    if (!isEmittingParticles) {
        self.isEnabled = NO;
    }
}

- (void) dealloc {
    if (_hasAllocatedMemory) {
        for (int i = 0; i < kMaxCollisionParticles; i++) {
            SBCollisionParticle* particle = _particles[i];
            
            free(particle);
        }    
    }
    
    [super dealloc];
}

@end
