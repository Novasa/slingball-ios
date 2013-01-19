//
//  NVInterpolatorVector3.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/25/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVInterpolatorVector3.h"

#import "NVGame.h"

@implementation NVInterpolatorVector3

@dynamic value;

+ (NVInterpolatorVector3*) interpolatorFrom: (kmVec3) from to: (kmVec3) to {
    NVInterpolatorVector3* interpolator = [[NVInterpolatorVector3 alloc] init];
    
    [interpolator interpolateFrom: from to: to];
    
    [[[NVGame sharedGame] scheduling] attachInterpolator: interpolator];
    
    return [interpolator autorelease];
}

- (void) interpolateFrom: (kmVec3) from to: (kmVec3) to {
    _from = from;
    _to = to;
}

- (kmVec3) value {
    kmVec3 value;
    kmVec3Lerp(&value, &_from, &_to, self.weight);
    
    return value;
}

@end
