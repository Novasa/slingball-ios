//
//  SBBallRibbonController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBallRibbonController.h"

@implementation SBBallRibbonController

- (void) start {
    [super start];
    
    kmVec3 position;
    kmVec3Zero(&position);

    kmVec3 axis;
    kmVec3Fill(&axis, 0, 1, 0);
    
    for (int i = 0; i < kMaxBallRibbonSegments; i++) {
        SBBallRibbonSegment* segment = malloc(sizeof(SBBallRibbonSegment));
        
        segment->position = position;
        segment->axis = axis;
        
        _segments[i] = segment;
    }
}

- (void) step: (float) t delta: (float) dt {
    SBBallRibbonSegment* last = _segments[kMaxBallRibbonSegments - 1];
    SBBallRibbonSegment* first = _segments[0];
    
    _segments[kMaxBallRibbonSegments - 1] = NULL;
    
    for (int i = kMaxBallRibbonSegments - 1; i > 0; i--) {
        SBBallRibbonSegment* next = _segments[i - 1];
        
        _segments[i] = next;
    }
    
    kmVec3 position = _transform.position;
    kmVec3 axis;

    if (kmVec3LengthSq(_collider.velocity) > kmEpsilon) {
        kmVec3 up;
        kmVec3Fill(&up, 0, 0, 1);

        kmVec3Cross(&axis, _collider.velocity, &up);

        kmVec3Normalize(&axis, &axis);
    } else {
        axis = first->axis;
    }
    
    last->position = position;
    last->axis = axis;
    
    _segments[0] = last;
}

- (SBBallRibbonSegment*) segmentAtIndex: (NSUInteger) index {
    if (index < kMaxBallRibbonSegments) {
        return _segments[index];
    }
    
    return NULL;
}

@end
