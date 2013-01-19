//
//  NVSoftSpringBody.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVSoftSpringBody.h"

static inline void SpringComputeSingleForce(kmVec3 *force, kmVec3 *pa, kmVec3 *pb, float k, float delta_distance) {
	kmVec3 force_dir;
    
	float intensity;
	float distance;
	float delta;
    
	float dx = pb->x-pa->x;
	float dy = pb->y-pa->y;
	float dz = pb->z-pa->z;
    
	distance = (float)sqrt((dx*dx)+(dy*dy)+(dz*dz));
    
	if (distance < SPRING_TOLERANCE) {
		force->x =
		force->y =
		force->z = 0.0f;
        
		return;
	}
    
	force_dir.x = dx;
	force_dir.y = dy;
	force_dir.z = dz;
    
	force_dir.x /= distance;
	force_dir.y /= distance;
	force_dir.z /= distance;
    
	delta = distance-delta_distance;
	intensity = k*delta;
    
	force->x = force_dir.x*intensity;
	force->y = force_dir.y*intensity;
	force->z = force_dir.z*intensity;
}

@implementation NVSoftSpringBody

- (void) accumulateForces {
    int tmp1;
	int tmp0;
	kmVec3 force_tmp;
	NVSpringParticle* node_curr;
	kmVec3*	source;
	kmVec3*	dest;
	float distance;
	kmVec3 resultant;
    
	for (tmp1=0; tmp1<_particleCount; tmp1++) {
		node_curr = _particles[tmp1];
        
		resultant.x	=
		resultant.y	=
		resultant.z	= 0.0f;
        
		source = &node_curr->position;
        
		for (tmp0=0; tmp0<node_curr->neighborCount; tmp0++) {
			dest = &node_curr->neighbors[tmp0]->position;
			distance = node_curr->neighborDistance[tmp0];
            
			SpringComputeSingleForce (&force_tmp,
                                      source,
                                      dest,
                                      _kCoefficient,
                                      distance);
            
            kmVec3Add(&resultant, &resultant, &force_tmp);
		}
        
		node_curr->force = resultant;
	}
}

- (void) applyForces {
 	int	tmp0;
	NVSpringParticle* node_curr;
	kmVec3 acc;
    
    kmVec3 gravity;
    kmVec3Fill(&gravity, 0.0f, 0.0f, 0.0f);
    
	//apply resultant forces to increase vel of each spring
	for (tmp0=0; tmp0<_particleCount; tmp0++) {
		node_curr = _particles[tmp0];
        
		//mass is in somehow unecessary
		//acc.x	= (node_curr->force.x+g_SpringGravity.x)/spring->mass;
		acc.x = (node_curr->force.x+gravity.x); 
        
		//acc.y	= (node_curr->force.y+g_SpringGravity.y)/spring->mass;
		acc.y = (node_curr->force.y+gravity.y); 
        
		//acc.z	= (node_curr->force.z+g_SpringGravity.z)/spring->mass;
		acc.z = (node_curr->force.z+gravity.z); 
        
		node_curr->velocity.x += acc.x;
		node_curr->velocity.y += acc.y;
		node_curr->velocity.z += acc.z;
        
		node_curr->position.x += node_curr->velocity.x;
		node_curr->position.y += node_curr->velocity.y;
		node_curr->position.z += node_curr->velocity.z;
        
		//energy loss for velocity
		node_curr->velocity.x *= _energyLoss;
        node_curr->velocity.y *= _energyLoss;
		node_curr->velocity.z *= _energyLoss;
        /*
        node_curr->velocity.x *= 1.15f;
        node_curr->velocity.y *= 1.15f;
        node_curr->velocity.z *= 1.15f;*/
	}
}

- (void) anchorCheck {
	int	tmp0;
	NVSpringParticle* node_curr;
    NVSpringParticleAnchor* anchor;
    
	for (tmp0 = 0; tmp0 < _anchorCount; tmp0++) {
        anchor = _anchors[tmp0];
		node_curr = anchor->particle;
        
		if (node_curr->position.x != anchor->position.x) {
			node_curr->position.x = anchor->position.x;
		}
        
		if (node_curr->position.y != anchor->position.y) {
			node_curr->position.y = anchor->position.y;
		}
        
		if (node_curr->position.z != anchor->position.z) {
			node_curr->position.z = anchor->position.z;
		}
	}
}

@synthesize kCoefficient = _kCoefficient;
@synthesize energyLoss = _energyLoss;
@synthesize mass = _mass;

@synthesize particleCount = _particleCount;
@synthesize anchorCount = _anchorCount;

- (id) init {
    if (self = [super init]) {
        _kCoefficient = 0.3f;
        _energyLoss = 0.98f;
        _mass = 1.0f;
    }
    return self;
}

- (void) step: (float) t delta: (float) dt { 
    [self accumulateForces];
    [self applyForces];
    [self anchorCheck];
}

- (NVSpringParticle*) createParticleAtPosition: (kmVec3) position {
    NVSpringParticle* particle = malloc(sizeof(NVSpringParticle));
    
    kmVec3 force;
    kmVec3Zero(&force);
    
    kmVec3 velocity;
    kmVec3Zero(&velocity);
    
    particle->position = position;
    particle->velocity = velocity;
    particle->force = force;
    particle->neighborCount = 0;
    
    _particles[_particleCount++] = particle;
    
    return particle;
}

- (NVSpringParticleAnchor*) createParticleAnchorWithParticle: (NVSpringParticle*) particle {
    return [self createParticleAnchorAtPosition: particle->position withParticle: particle];
}

- (NVSpringParticleAnchor*) createParticleAnchorAtPosition: (kmVec3) position withParticle: (NVSpringParticle*) particle {
    NVSpringParticleAnchor* anchor = malloc(sizeof(NVSpringParticleAnchor));
    
    anchor->position = position;
    anchor->particle = particle;
    
    _anchors[_anchorCount++] = anchor;
    
    return anchor;
}

- (void) connectParticle: (NVSpringParticle*) particleA withParticle: (NVSpringParticle*) particleB {
    float distance = kmVec3DistanceSq(&particleA->position, &particleB->position);
    
    particleA->neighbors[particleA->neighborCount] = particleB;
    particleA->neighborDistance[particleA->neighborCount] = distance;
    particleA->neighborCount++;
    
    particleB->neighbors[particleB->neighborCount] = particleA;
    particleB->neighborDistance[particleB->neighborCount] = distance;
    particleB->neighborCount++;
}

- (NVSpringParticle*) particleAtIndex: (NSUInteger) index {
    if (index < _particleCount) {
        return _particles[index];
    }
    
    return NULL;
}

- (NVSpringParticleAnchor*) particleAnchorAtIndex: (NSUInteger) index {
    if (index < _anchorCount) {
        return _anchors[index];
    }
    
    return NULL;
}

- (void) dealloc {
    for (int i = _particleCount; i >= 0; i--) {
        NVSpringParticle* particle = _particles[i];
        
        free(particle);
        
        _particleCount--;
    }
    
    for (int i = _anchorCount; i >= 0; i--) {
        NVSpringParticleAnchor* anchor = _anchors[i];
        
        free(anchor);
        
        _anchorCount--;
    }
    
    [super dealloc];
}

@end
