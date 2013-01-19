//
//  SBBall.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

@interface SBBall : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
}

@end
