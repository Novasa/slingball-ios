//
//  NVDebugShowSpringParticleVelocities.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/2/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"
#import "NVSoftSpringBody.h"

@interface NVDebugShowSpringParticleVelocities : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(NVSoftSpringBody, _springBody);
}

@end
