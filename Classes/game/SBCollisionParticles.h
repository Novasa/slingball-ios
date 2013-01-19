//
//  SBCollisionParticles.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/3/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

#import "SBCollisionParticlesController.h"

@interface SBCollisionParticles : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBCollisionParticlesController, _controller);
}

@end
