//
//  SBSplashParticles.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBSplashParticlesController.h"

#import "NVRenderable.h"
#import "NVTransformable.h"

@interface SBSplashParticles : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBSplashParticlesController, _controller);
}

@end
