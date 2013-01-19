//
//  SBGoalSpriteController.h
//  slingball
//
//  Created by Jacob H. Hansen on 2/24/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"

@interface SBGoalSpriteController : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
}

@end
