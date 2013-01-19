//
//  SBPlayingFieldSweepController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBPlayingFieldSweepController.h"

#import "NVAudioCache.h"

#import "SBGlobalAudioSource.h"

@implementation SBPlayingFieldSweepController

@dynamic color;

@synthesize velocity = _velocity;

- (id) init {
    if (self = [super init]) {
        _velocity = 2.5f;
        _speedModifier = 1.0f;
        
        self.isEnabled = NO;
    }
    return self;
}

- (void) step: (float) t delta: (float) dt { 
    kmVec3 currentPosition = _transform.position;
    kmVec3 currentScale = _transform.scale;

    float fieldHeight = (_playingFieldController.height / 2);
    float sweepHeight = currentScale.y / 2;
    
    float y = currentPosition.y;
    
    float top = y + sweepHeight;
    float bottom = y - sweepHeight;

    y += (_velocity * _speedModifier) * dt;
        
    if (top > fieldHeight) {
        y = top - sweepHeight;
        
        _reachedTop = YES;
    } else if (bottom < -fieldHeight) {
        y = bottom + sweepHeight;

        _reachedBottom = YES;
    }

    if (_reachedTop) {
        if (_velocity > 0) {
            currentScale.y += -_velocity * dt;
            
            if (currentScale.y < 0) { 
                currentScale.y = 0;
                
                _velocity = -_velocity;
            }
        } else {
            currentScale.y += -_velocity * dt;
            
            if (currentScale.y > 2.5f) {
                currentScale.y = 2.5f;
                
                _reachedTop = NO;
            }
        }
    } else if (_reachedBottom) {
        if (_velocity < 0) {
            currentScale.y += _velocity * dt;
            
            if (currentScale.y < 0) { 
                currentScale.y = 0;
                
                _velocity = -_velocity;
            }
        } else {
            currentScale.y += _velocity * dt;
            
            if (currentScale.y > 2.5f) {
                currentScale.y = 2.5f;
                
                _reachedBottom = NO;
            }
        }
    }

    currentPosition.y = y;
    
    _transform.position = currentPosition;
    _transform.scale = currentScale;

    SBSlingHeadCollider* collider = _playerIndex == 1 ? _playerOneCollider : _playerTwoCollider;
    
    float const a = 
        _velocity > 0 ? 
            collider.position->y - collider.radius : 
            collider.position->y + collider.radius;
    
    float const b = 
        _velocity > 0 ? 
            top : 
            bottom;
    
    BOOL beamIsNearCollider = fabs(a - b) < 0.1f;
    
    if (beamIsNearCollider) {
        NVTransformable* explosionTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: _playerExplosion.group];
        
        kmVec3 pos;
        kmVec3Assign(&pos, collider.position);
        
        explosionTransform.position = pos;
        
        if (_playerIndex == 1) {
            if (_playerOneHead.isVisible) {         
                [[NVAudioCache sharedCache] playSoundWithKey: kAudioExplosion gain: 1.0f pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
                
                [_playerExplosion resetForPlayerIndex: 1];
                
                _playerExplosion.isEnabled = YES;
                _playerOneHead.isVisible = NO;
            }
        } else if (_playerIndex == 2) {
            if (_playerTwoHead.isVisible) {
                [[NVAudioCache sharedCache] playSoundWithKey: kAudioExplosion gain: 1.0f pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
                
                [_playerExplosion resetForPlayerIndex: 2];
                
                _playerExplosion.isEnabled = YES;
                _playerTwoHead.isVisible = NO;
            }
        }
    }
}

- (NVColor4f) color {
    NVColor4f color;
    
    if (_playerIndex == 1) {
        color = NVColor4fMake(0, 0, 1, 1);
    } else if (_playerIndex == 2){
        color = NVColor4fMake(1, 0, 0, 1);        
    }
    
    return color;
}

- (void) sweepForPlayerIndex: (NSUInteger) index {
    _playerIndex = index;

    _reachedBottom = NO;
    _reachedTop = NO;
    
    static float const height = 2.5f;
    float const h = (height / 2);
    
    kmVec3 scale;
    kmVec3Fill(&scale, _playingFieldController.width, height, 1);
    
    _transform.scale = scale;
    
    kmVec3 position;
    
    if (index == 1) {
        kmVec3Fill(&position, 0, (_playingFieldController.height / 2) - h, 0);        
        
        _velocity = -(fabs(_velocity));
    } else if (index == 2) {
        kmVec3Fill(&position, 0, -(_playingFieldController.height / 2) + h, 0);
        
        _velocity = fabs(_velocity);
    }
        
    _transform.position = position;
    
    self.isEnabled = YES;
}

@end
