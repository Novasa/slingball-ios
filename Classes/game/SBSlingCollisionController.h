//
//  SBSlingCollisionController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBCollisionController.h"

#import "SBPlayingFieldController.h"

#import "SBSlingHeadCollider.h"
#import "SBBallCollider.h"

@interface SBSlingCollisionController : SBCollisionController {
 @private
    REQUIRES(SBSlingHeadCollider, _slingCollider);
    
    REQUIRES_FROM_GROUP(SBBallCollider, _ballCollider, ball);
    REQUIRES_FROM_GROUP(SBPlayingFieldController, _playingFieldController, playing_field);
    
    BOOL _shouldReturnCameraToOriginalPosition;
}

@end
