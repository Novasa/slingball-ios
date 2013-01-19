//
//  SBUIMenuPlayController.h
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

@interface SBUIMenuPlayController : SBUIMenuController <NVInterpolatorDelegate> {
 @private
    REQUIRES_FROM_GROUP(NVTransformable, _cameraTransform, camera);
    REQUIRES_FROM_GROUP(NVLookAtCamera, _camera, camera);
    
    kmVec3 _cameraOriginalTarget;
    kmVec3 _cameraDesiredTarget;
    
    kmVec3 _cameraOriginalPosition;
    kmVec3 _cameraDesiredPosition;
    
    kmQuaternion _cameraOriginalRotation;
    kmQuaternion _cameraDesiredRotation;
}

@end
