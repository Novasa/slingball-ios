//
//  SBGoalController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/5/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"

#import "SBGoalBody.h"
#import "SBBallCollider.h"
#import "SBGoalControllerDelegate.h"

@interface SBGoalController : NVSchedulable {
 @private
    REQUIRES(SBGoalBody, _body);
    
    REQUIRES_FROM_GROUP(SBBallCollider, _ballCollider, ball);
                
    float _strength;
    
    BOOL _hasCalculatedBounds;
    
    NVSphere _bounds;
    
    id<SBGoalControllerDelegate> _delegate;
}

@property(nonatomic, readwrite, assign) id<SBGoalControllerDelegate> delegate;

- (void) calculateBounds;

@end
