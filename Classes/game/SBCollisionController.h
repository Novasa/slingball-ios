//
//  SBCollisionController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"

#import "SBCollisionControllerDelegate.h"

typedef enum {
    SBCollisionWallNone = 0,
    SBCollisionWallLeft = 1,
    SBCollisionWallRight = 2,
    SBCollisionWallUp = 4,
    SBCollisionWallDown = 8
} SBCollisionWall;

@interface SBCollisionController : NVComponent {
 @private
    id<SBCollisionControllerDelegate> _delegate;
}

@property(nonatomic, readwrite, assign) id<SBCollisionControllerDelegate> delegate;

- (void) resolve;

- (void) resolvedCollisionAtContactPoint: (kmVec3) contactPoint;
- (void) resolvedCollisionBetweenCollidable: (SBCollidable*) collidable andCollidable: (SBCollidable*) collidable atContactPoint: (kmVec3) contactPoint;

+ (SBCollisionWall) innerWallCollisionForSphereWithCenter: (kmVec3*) center andRadius: (float) radius againstBoundaries: (NVAABB) boundaries;

@end
