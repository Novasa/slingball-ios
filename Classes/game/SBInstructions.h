//
//  SBInstructions.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/26/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

#import "SBInstructionsController.h"

@interface SBInstructions : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBInstructionsController, _controller);
}

@end
