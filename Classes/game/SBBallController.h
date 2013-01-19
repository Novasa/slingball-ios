//
//  SBBallController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"
#import "SBPlayingFieldController.h"

@interface SBBallController : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    REQUIRES_FROM_GROUP(SBPlayingFieldController, _playingFieldController, playing_field);
    
    kmVec3* _velocity;
}

@property(nonatomic, readonly) kmVec3* velocity;

- (void) reset;

@end
