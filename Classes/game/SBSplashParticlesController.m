//
//  SBSplashParticlesController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSplashParticlesController.h"

@implementation SBSplashParticlesController

- (id) init {
    if (self = [super init]) {
        _hasAllocatedMemory = NO;
    }
    return self;
}

- (void) start {
    [super start];
    
    [self reset];
}

- (void) resetParticle: (SBSplashParticle*) particle {
    float x = random_float() * 1.1f;
    float y = 0;
    
    if (_hasAllocatedMemory) {
        y = 2.0f + random_float();
    } else {
        y = 2.0f * random_float();
        y = rand() % 2 > 0 ? y : -y;
    }
    
    float z = 0.333f + (random_float() * 0.65f);
    
    x = rand() % 2 > 0 ? x : -x;
    
    kmVec3Fill(&particle->position, x, y, z);
    
    particle->speed = 0.65f + random_float();
    
    particle->scale = 0.1f + random_float();
    
    particle->angleRotationX = kmRadiansToDegrees(random_float());
    particle->angleRotationY = kmRadiansToDegrees(random_float());
    particle->angleRotationZ = kmRadiansToDegrees(random_float());
}

- (void) reset {
    for (int i = 0; i < kMaxSplashParticles; i++) {
        if (!_hasAllocatedMemory) {
            _particles[i] = malloc(sizeof(SBSplashParticle));
        }
        
        SBSplashParticle* particle = _particles[i];
        
        [self resetParticle: particle];
    }    
    
    if (!_hasAllocatedMemory) {
        _hasAllocatedMemory = YES;
    }
}

- (SBSplashParticle*) particleAtIndex: (NSUInteger) index {
    if (index < kMaxSplashParticles) {
        return _particles[index];
    }
    
    return NULL;
}

- (void) step: (float) t delta: (float) dt { 
    for (int i = 0; i < kMaxSplashParticles; i++) {
        SBSplashParticle* particle = _particles[i];
        
        kmVec3 position = particle->position;
        
        if (position.y < -2.5f) {
            [self resetParticle: particle];
        } else {
            float rotation = kmRadiansToDegrees(particle->speed * dt);
            
            //particle->angleRotationX += rotation * 0.25f;
            //particle->angleRotationY += rotation * 0.33f;
            particle->angleRotationZ += rotation * 0.9f;
            
            kmVec3 direction;
            kmVec3Fill(&direction, 0, -1, 0);
            kmVec3Scale(&direction, &direction, particle->speed * dt);
            
            kmVec3Add(&particle->position, &particle->position, &direction);
        }
    }
}

- (void) dealloc {
    if (_hasAllocatedMemory) {
        for (int i = 0; i < kMaxSplashParticles; i++) {
            SBSplashParticle* particle = _particles[i];
            
            free(particle);
        }    
    }
    
    [super dealloc];
}

@end
