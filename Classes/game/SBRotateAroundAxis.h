//
//  SBRotateAroundAxis.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/26/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"

@interface SBRotateAroundAxis : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    kmVec3* _axis;
    
    float _speed;
    float _angle;
}

@property(nonatomic, readonly) kmVec3* axis;
@property(nonatomic, readwrite, assign) float speed;

@end
