//
//  SBCollisionParticlesController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/3/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"

#define kMaxCollisionParticles 24

typedef	struct {
	kmVec3 position;
	kmVec3 velocity;
	
	float life;
    float decay;
} SBCollisionParticle;

@interface SBCollisionParticlesController : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    BOOL _hasAllocatedMemory;
    
    SBCollisionParticle* _particles[kMaxCollisionParticles];
}

- (void) reset;

- (SBCollisionParticle*) particleAtIndex: (NSUInteger) index;

@end
