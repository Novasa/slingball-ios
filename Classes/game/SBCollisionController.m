//
//  SBCollisionController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBCollisionController.h"

@implementation SBCollisionController

@synthesize delegate = _delegate;

+ (SBCollisionWall) innerWallCollisionForSphereWithCenter: (kmVec3*) center andRadius: (float) radius againstBoundaries: (NVAABB) boundaries {
    SBCollisionWall result = SBCollisionWallNone;
/*
    BOOL isWithinBoundaries = 
        center->x > boundaries.min.x && center->x < boundaries.max.x && 
        center->y > boundaries.min.y && center->y < boundaries.max.y;
    
    if (isWithinBoundaries) {
        if (center->x - radius <= boundaries.min.x) {
            result = SBCollisionWallLeft;
        } else if (center->x + radius >= boundaries.max.x) {
            result = SBCollisionWallRight;
        }
        
        if (center->y - radius <= boundaries.min.y) {
            if (result != SBCollisionWallNone) {
                result |= SBCollisionWallDown;
            } else {
                result = SBCollisionWallDown;
            }
        } else if (center->y + radius >= boundaries.max.y) {
            if (result != SBCollisionWallNone) {
                result |= SBCollisionWallUp;
            } else {
                result = SBCollisionWallUp;
            }
        }
    }
*/    
    if (center->x - radius <= boundaries.min.x) {
        result = SBCollisionWallLeft;
    } else if (center->x + radius >= boundaries.max.x) {
        result = SBCollisionWallRight;
    }
    
    if (center->y - radius <= boundaries.min.y) {
        if (result != SBCollisionWallNone) {
            result |= SBCollisionWallDown;
        } else {
            result = SBCollisionWallDown;
        }
    } else if (center->y + radius >= boundaries.max.y) {
        if (result != SBCollisionWallNone) {
            result |= SBCollisionWallUp;
        } else {
            result = SBCollisionWallUp;
        }
    }
    
    return result;
}

- (void) resolve {
    
}

- (void) resolvedCollisionAtContactPoint: (kmVec3) contactPoint {
    if (_delegate != nil) {
        SEL callback = @selector(collisionController:detectedCollisionAtContactPoint:);
        
        if ([_delegate respondsToSelector: callback]) {
            [_delegate collisionController: self detectedCollisionAtContactPoint: contactPoint];
        }
    }
}

- (void) resolvedCollisionBetweenCollidable: (SBCollidable*) collidableA andCollidable: (SBCollidable*) collidableB atContactPoint: (kmVec3) contactPoint {
    if (_delegate != nil) {
        SEL callback = @selector(collisionController:detectedCollisionBetweenCollidable:andCollidable:atContactPoint:);
        
        if ([_delegate respondsToSelector: callback]) {
            [_delegate collisionController: self detectedCollisionBetweenCollidable: collidableA andCollidable: collidableB atContactPoint: contactPoint];
        }
    }
}

- (void) dealloc {
    if (_delegate != nil) {
        _delegate = nil;
    }
    
    [super dealloc];
}

@end
