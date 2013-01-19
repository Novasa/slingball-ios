//
//  SBSlingRibbonController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/12/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingRibbonController.h"

@implementation SBSlingRibbonController

- (id) init {
    if (self = [super init]) {

    }
    return self;
}

- (void) start {
    [super start];
    
    kmVec3 position;
    kmVec3Zero(&position);
    
    kmVec3 axis;
    kmVec3Fill(&axis, 0, 1, 0);

    for (int i = 0; i < kMaxRibbonSegments; i++) {
        SBSlingRibbonSegment* segment = malloc(sizeof(SBSlingRibbonSegment));
        
        segment->position = position;
        segment->axis = axis;
        
        _segments[i] = segment;
    }
}

- (void) step: (float) t delta: (float) dt {
    NVSpringParticle* head = [_body head];
    
    if (head == NULL) {    
        return;
    }
    
    SBSlingRibbonSegment* last = _segments[kMaxRibbonSegments - 1];
    SBSlingRibbonSegment* first = _segments[0];
    
    _segments[kMaxRibbonSegments - 1] = NULL;
    
    for (int i = kMaxRibbonSegments - 1; i > 0; i--) {
        SBSlingRibbonSegment* next = _segments[i - 1];
        
        _segments[i] = next;
    }
    
    kmVec3 position = head->position;
    
    kmVec3 axis;
    
    if (kmVec3LengthSq(&[_body head]->velocity) > kmEpsilon) {
        kmVec3 up;
        kmVec3Fill(&up, 0, 0, 1);
        
        kmVec3Cross(&axis, &[_body head]->velocity, &up);
        
        kmVec3Normalize(&axis, &axis);
    } else {
        axis = first->axis;
    }
    
    last->position = position;
    last->axis = axis;
    
    _segments[0] = last;
}

- (SBSlingRibbonSegment*) segmentAtIndex: (NSUInteger) index {
    if (index < kMaxRibbonSegments) {
        return _segments[index];
    }
    
    return NULL;
}

@end
