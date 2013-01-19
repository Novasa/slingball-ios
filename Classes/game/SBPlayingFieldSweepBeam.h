//
//  SBPlayingFieldSweepBeam.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

#import "SBPlayingFieldSweepController.h"

@interface SBPlayingFieldSweepBeam : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBPlayingFieldSweepController, _controller);
}

@end
