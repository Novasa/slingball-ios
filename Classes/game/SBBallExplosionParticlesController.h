//
//  SBBallExplosionParticlesController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/24/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"

#define kMaxBallExplosionParticles 64

typedef	struct {
	kmVec3 position;
	kmVec3 velocity;
	
	float life;
    float decay;
} SBBallExplosionParticle;

@interface SBBallExplosionParticlesController : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    kmVec3* _gravity;
    
    BOOL _hasAllocatedMemory;
    
    SBBallExplosionParticle* _particles[kMaxBallExplosionParticles];
}
    
- (void) reset;
    
- (SBBallExplosionParticle*) particleAtIndex: (NSUInteger) index;

@end
