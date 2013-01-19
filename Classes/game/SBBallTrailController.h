//
//  SBBallTrailController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/8/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"

#import "SBBallController.h"
#import "SBBallCollider.h"

#define kMaxBallTrailParticles 20

typedef	struct {
	kmVec3 position;
	kmVec3 velocity;
	
	float life;
} SBBallTrailParticle;

@interface SBBallTrailController : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBBallController, _ballController);
    REQUIRES(SBBallCollider, _ballCollider);
    /*
    REQUIRES_FROM_GROUP(NVTransformable, _ballTransform, game_ball);
    REQUIRES_FROM_GROUP(SBBallCollider, _ballCollider, game_ball);
    */
    BOOL _hasAllocatedMemory;
    
    SBBallTrailParticle* _particles[kMaxBallTrailParticles];
    
    float _timeElapsedSincePreviousSpawn;
    float _spawnInterval;
}

- (void) reset;

- (SBBallTrailParticle*) particleAtIndex: (NSUInteger) index;

@end
