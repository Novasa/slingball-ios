//
//  SBPlayingFieldController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBPlayingFieldController.h"

@implementation SBPlayingFieldController

@synthesize friction = _friction;

@dynamic width;
@dynamic height;

@dynamic goalWidth;
@dynamic goalHeight;

- (id) init {
    if (self = [super init]) {
        _friction = 0.985f;
    }
    return self;
}

- (float) width {
    kmVec3 scale = _transform.scale;
    return scale.x;
}

- (float) height {
    kmVec3 scale = _transform.scale;
    return scale.y;
}

- (float) goalWidth {
    kmVec3 scale = _transform.scale;
    return scale.x * 0.333f;
}

- (float) goalHeight {
    kmVec3 scale = _transform.scale;
    return scale.y * 0.1f;
}

@end
