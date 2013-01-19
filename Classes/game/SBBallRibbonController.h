//
//  SBBallRibbonController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVTransformable.h"
#import "NVSchedulable.h"

#import "SBBallCollider.h"

#define kMaxBallRibbonSegments 24

typedef struct {
    kmVec3 position;
    kmVec3 axis;
} SBBallRibbonSegment;

@interface SBBallRibbonController : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBBallCollider, _collider);
    
    SBBallRibbonSegment* _segments[kMaxBallRibbonSegments];
}

- (SBBallRibbonSegment*) segmentAtIndex: (NSUInteger) index;

@end
