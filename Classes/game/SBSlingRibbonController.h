//
//  SBSlingRibbonController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/12/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"

#import "SBSlingBody.h"

#define kMaxRibbonSegments 12

typedef struct {
    kmVec3 position;
    kmVec3 axis;
} SBSlingRibbonSegment;

@interface SBSlingRibbonController : NVSchedulable {
 @private
    REQUIRES(SBSlingBody, _body);
    
    SBSlingRibbonSegment* _segments[kMaxRibbonSegments];
}

- (SBSlingRibbonSegment*) segmentAtIndex: (NSUInteger) index;

@end
