//
//  NVSoftSpringBody.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"

#define	SPRING_MAX_NEIGHBOR_COUNT		(32)
#define	SPRING_TOLERANCE				(0.0000000005f)
#define	SPRING_MAX_NODE_COUNT			(256)
#define	SPRING_MAX_ANCHOR_NODE_COUNT	(256)

typedef struct NVSpringParticle NVSpringParticle;
typedef struct NVSpringParticleAnchor NVSpringParticleAnchor;

struct NVSpringParticle {
    kmVec3 position;
    kmVec3 velocity;
    kmVec3 force;
    
    NVSpringParticle* neighbors[SPRING_MAX_NEIGHBOR_COUNT];
    float neighborDistance[SPRING_MAX_NEIGHBOR_COUNT];
    int neighborCount;
};

struct NVSpringParticleAnchor {
    kmVec3 position;
    
    NVSpringParticle* particle;
};

@interface NVSoftSpringBody : NVSchedulable {
 @private
    NVSpringParticle* _particles[SPRING_MAX_NODE_COUNT];
    NSUInteger _particleCount;
    
    NVSpringParticleAnchor* _anchors[SPRING_MAX_ANCHOR_NODE_COUNT];
    NSUInteger _anchorCount;
    
    float _kCoefficient;
    float _energyLoss;
    float _mass;
}

@property(nonatomic, readwrite, assign) float kCoefficient;
@property(nonatomic, readwrite, assign) float energyLoss;
@property(nonatomic, readwrite, assign) float mass;

@property(nonatomic, readonly) NSUInteger particleCount;
@property(nonatomic, readonly) NSUInteger anchorCount;

- (NVSpringParticle*) createParticleAtPosition: (kmVec3) position;
- (NVSpringParticleAnchor*) createParticleAnchorWithParticle: (NVSpringParticle*) particle;
- (NVSpringParticleAnchor*) createParticleAnchorAtPosition: (kmVec3) position withParticle: (NVSpringParticle*) particle;

- (void) connectParticle: (NVSpringParticle*) particleA withParticle: (NVSpringParticle*) particleB;

- (NVSpringParticle*) particleAtIndex: (NSUInteger) index;
- (NVSpringParticleAnchor*) particleAnchorAtIndex: (NSUInteger) index;

@end
