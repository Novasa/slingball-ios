//
//  SBBallCollider.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBCollidable.h"
#import "SBBallController.h"

#import "NVTransformable.h"

@interface SBBallCollider : SBCollidable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBBallController, _controller);
    
    SBCollidable* _mostRecentCollider;
}

@property(nonatomic, readonly) float radius;

@property(nonatomic, readonly) kmVec3 position;
@property(nonatomic, readonly) kmVec3* velocity;

@property(nonatomic, readwrite, assign) SBCollidable* mostRecentCollider;

@end
