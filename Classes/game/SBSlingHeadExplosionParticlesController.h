//
//  SBSlingHeadExplosionParticlesController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"
    
#define kMaxSlingHeadExplosionParticles 128
    
typedef	struct {
    kmVec3 position;
    kmVec3 velocity;
    
    NVColor4f color;
    
    float life;
    float decay;
} SBSlingHeadExplosionParticle;

@interface SBSlingHeadExplosionParticlesController : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    kmVec3* _gravity;
    
    BOOL _hasAllocatedMemory;
    
    SBSlingHeadExplosionParticle* _particles[kMaxSlingHeadExplosionParticles];
}

- (void) resetForPlayerIndex: (NSUInteger) index;

- (SBSlingHeadExplosionParticle*) particleAtIndex: (NSUInteger) index;

@end
