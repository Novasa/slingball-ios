//
//  SBSplashParticlesController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"

#define kMaxSplashParticles 76

typedef struct {
    kmVec3 position;
    
    float speed;
    
    float scale;
    
    float angleRotationX;
    float angleRotationY;
    float angleRotationZ;
} SBSplashParticle;

@interface SBSplashParticlesController : NVSchedulable {
 @private
    BOOL _hasAllocatedMemory;
    
    SBSplashParticle* _particles[kMaxSplashParticles];
}

- (void) reset;

- (SBSplashParticle*) particleAtIndex: (NSUInteger) index;

@end
