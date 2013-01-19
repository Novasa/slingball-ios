//
//  SBGlowingBoxBoundary.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/10/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

@interface SBGlowingBoxBoundary : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
}

@end
