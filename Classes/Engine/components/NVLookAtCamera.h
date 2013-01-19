//
//  NVLookAtCamera.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/19/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVCamera.h"
#import "NVTransformable.h"
#import "NVTransformableDelegate.h"

@interface NVLookAtCamera : NVCamera <NVTransformableDelegate> {
@private
    REQUIRES(NVTransformable, _transform);
    
    kmVec3* _target;
    kmVec3* _up;
}

@property(nonatomic, readonly) kmVec3* up;
@property(nonatomic, readonly) kmVec3* target;

@end
