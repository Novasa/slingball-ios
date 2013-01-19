//
//  SBSlingHeadExplosionParticles.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"

#import "SBSlingHeadExplosionParticlesController.h"

@interface SBSlingHeadExplosionParticles : NVRenderable {
 @private
    REQUIRES(SBSlingHeadExplosionParticlesController, _controller);
}

@end
