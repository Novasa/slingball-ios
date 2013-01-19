//
//  SBFloatingGoalText.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

#import "SBFloatingTextController.h"

@interface SBFloatingText : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBFloatingTextController, _controller);
}

@end
