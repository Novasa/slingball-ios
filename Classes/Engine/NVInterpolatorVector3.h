//
//  NVInterpolatorVector3.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/25/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVInterpolator.h"

@interface NVInterpolatorVector3 : NVInterpolator {
 @private
    kmVec3 _from;
    kmVec3 _to;
}

@property(nonatomic, readonly) kmVec3 value;

+ (NVInterpolatorVector3*) interpolatorFrom: (kmVec3) from to: (kmVec3) to;

- (void) interpolateFrom: (kmVec3) from to: (kmVec3) to;

@end
