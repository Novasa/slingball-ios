//
//  SBBallCollider.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBallCollider.h"

@implementation SBBallCollider

@synthesize mostRecentCollider = _mostRecentCollider;

- (float) radius {
    return _transform.scale.x;
}

- (kmVec3) position {
    return _transform.position;
}

- (kmVec3*) velocity {
    return _controller.velocity;
}

@end
