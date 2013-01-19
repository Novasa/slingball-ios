//
//  SBPlayingFieldSweepController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTransformable.h"

#import "SBPlayingFieldController.h"

#import "SBSlingHeadCollider.h"
#import "SBSlingHead.h"

#import "SBSlingHeadExplosionParticlesController.h"

@interface SBPlayingFieldSweepController : NVSchedulable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    REQUIRES_FROM_GROUP(SBPlayingFieldController, _playingFieldController, playing_field);
    
    REQUIRES_FROM_GROUP(SBSlingHead, _playerOneHead, player_one);
    REQUIRES_FROM_GROUP(SBSlingHead, _playerTwoHead, player_two);
    
    REQUIRES_FROM_GROUP(SBSlingHeadCollider, _playerOneCollider, player_one);
    REQUIRES_FROM_GROUP(SBSlingHeadCollider, _playerTwoCollider, player_two);
    
    REQUIRES_FROM_GROUP(SBSlingHeadExplosionParticlesController, _playerExplosion, player_explosion);
    
    float _velocity;
    float _speedModifier;

    NSUInteger _playerIndex;
    
    BOOL _reachedTop;
    BOOL _reachedBottom;
}

@property(nonatomic, readonly) NVColor4f color;

@property(nonatomic, readonly) float velocity;

- (void) sweepForPlayerIndex: (NSUInteger) index;

@end
