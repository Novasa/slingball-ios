//
//  SBSlingHeadExplosionParticlesController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingHeadExplosionParticlesController.h"

@implementation SBSlingHeadExplosionParticlesController

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
    
    [self resetForPlayerIndex: 1];
}

- (void) resetParticle: (SBSlingHeadExplosionParticle*) particle forPlayerIndex: (NSUInteger) index {
    particle->life = 1.0f;
    particle->decay = (random_float() + 0.1f) * 0.65f;
    
    float const g = random_float() * 0.1f;
    
    particle->color = 
        index == 1 ? 
            NVColor4fMake(1, g, 0, 1) :
            NVColor4fMake(0, g, 1, 1);
    
    kmVec3 origin = _transform.position;
    kmVec3Assign(&particle->position, &origin);
    
    kmVec3 velocity;
    assign_random_orbital_axis(&velocity);
    
    if (velocity.z < 0) {
        velocity.z = -velocity.z;
    }
    
    velocity.z *= 6.5f;
    
    float speed = random_float() + 0.333f;
    
    kmVec3Scale(&particle->velocity, &velocity, speed);    
}

- (void) resetForPlayerIndex: (NSUInteger) index {
    for (int i = 0; i < kMaxSlingHeadExplosionParticles; i++) {
        if (!_hasAllocatedMemory) {
            _particles[i] = malloc(sizeof(SBSlingHeadExplosionParticle));
        }
        
        SBSlingHeadExplosionParticle* particle = _particles[i];
        
        [self resetParticle: particle forPlayerIndex: index];
    }    
    
    if (!_hasAllocatedMemory) {
        _hasAllocatedMemory = YES;
    }
}

- (SBSlingHeadExplosionParticle*) particleAtIndex: (NSUInteger) index {
    if (index < kMaxSlingHeadExplosionParticles) {
        return _particles[index];
    }
    
    return NULL;
}

- (void) step: (float) t delta: (float) dt { 
    BOOL isEmittingParticles = NO;
    
    for (int i = 0; i < kMaxSlingHeadExplosionParticles; i++) {
        SBSlingHeadExplosionParticle* particle = _particles[i];
        
        if (particle->life > 0) {
            particle->life -= particle->decay * dt;
            
            if (particle->life < 0) {
                particle->life = 0;
            }
            
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
        for (int i = 0; i < kMaxSlingHeadExplosionParticles; i++) {
            SBSlingHeadExplosionParticle* particle = _particles[i];
            
            free(particle);
        }    
    }
    
    [super dealloc];
}

@end
