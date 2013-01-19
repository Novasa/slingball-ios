//
//  SBCollisionControllerDelegate.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBCollisionController;
@class SBCollidable;

@protocol SBCollisionControllerDelegate <NSObject>
@optional
- (void) collisionController: (SBCollisionController*) controller detectedCollisionAtContactPoint: (kmVec3) contactPoint;
- (void) collisionController: (SBCollisionController*) controller detectedCollisionBetweenCollidable: (SBCollidable*) collidableA andCollidable: (SBCollidable*) collidableB atContactPoint: (kmVec3) contactPoint;
@end
