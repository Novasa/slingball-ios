//
//  SBBallExplosionParticles.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/24/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"

#import "SBBallExplosionParticlesController.h"

@interface SBBallExplosionParticles : NVRenderable {
 @private
    REQUIRES(SBBallExplosionParticlesController, _controller);
}

@end
