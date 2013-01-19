//
//  SBBallTrail.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/8/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "SBBallTrailController.h"

@interface SBBallTrail : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBBallTrailController, _controller);
}

@end
