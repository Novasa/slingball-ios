//
//  SBUIMenuMenuController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVLookAtCamera.h"
#import "NVTransformable.h"
#import "NVInterpolatorDelegate.h"

#import "SBUIMenuController.h"

@interface SBUIMenuMenuController : SBUIMenuController <NVInterpolatorDelegate> {
 @private
    REQUIRES_FROM_GROUP(NVTransformable, _cameraTransform, camera);
    REQUIRES_FROM_GROUP(NVLookAtCamera, _camera, camera);
    
    REQUIRES_FROM_GROUP(NVScreenSpacedRectangle, _overlay, dimmed_overlay);
    
    kmVec3 _cameraOriginalTarget;
    kmVec3 _cameraOriginalPosition;
}

@end
