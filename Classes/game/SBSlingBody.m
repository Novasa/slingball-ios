//
//  SBSlingBody.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingBody.h"

@implementation SBSlingBody

@synthesize scaleHead = _scaleHead;
@synthesize scaleTail = _scaleTail;

- (id) init {
    if (self = [super init]) {
        _scaleHead = 0.3f;
        _scaleTail = 0.1f;
        
        _playerIndex = 1;
        
        _slingHasBeenCreated = NO;
    }
    return self;
}

- (void) createSlingForPlayerIndex: (NSUInteger) index {    
    if (index == 0 || _slingHasBeenCreated) {
        return;
    }
    
    _playerIndex = index;
    
    float initialOffset = 0.75f;
    float y = index == 1 ? -initialOffset : initialOffset;
    
    kmVec3 tailPosition;
    kmVec3Fill(&tailPosition, 0, y, 0);
    
    NVSpringParticle* tail = [self createParticleAtPosition: tailPosition];
    
    NSUInteger segments = 3;
    
    float distanceBetweenPoints = 0.175f;
    float yoffset = tailPosition.y;
    
    NVSpringParticle* previousParticle = tail;
    
    for (int i = 0; i < segments; i++) {
        yoffset += index == 1 ? -distanceBetweenPoints : distanceBetweenPoints;
        
        distanceBetweenPoints *= 1.25f;
        
        kmVec3 segmentEndPosition;
        kmVec3Fill(&segmentEndPosition, 0, yoffset, 0);
        
        NVSpringParticle* segment = [self createParticleAtPosition: segmentEndPosition];
        
        [self connectParticle: previousParticle withParticle: segment];
        
        previousParticle = segment;
    }
    
    [self createParticleAnchorWithParticle: tail];
    
    _slingHasBeenCreated = YES;
}

- (void) restoreInitialState {
    [self restoreInitialStateForPlayerIndex: _playerIndex];
}

- (void) restoreInitialStateForPlayerIndex: (NSUInteger) index {
    if (index == 0 || !_slingHasBeenCreated) {
        return;
    }
    
    float initialOffset = 0.75f;
    float y = index == 1 ? -initialOffset : initialOffset;
    
    kmVec3 tailPosition;
    kmVec3Fill(&tailPosition, 0, y, 0);
    
    NVSpringParticle* tail = [self tail];
    NVSpringParticleAnchor* tailAnchor = [self anchor];
    
    kmVec3 tailVelocity;
    kmVec3Zero(&tailVelocity);
    
    tail->velocity = tailVelocity;
    tail->position = tailPosition;
    tailAnchor->position = tailPosition;
    
    float distanceBetweenPoints = 0.175f;
    float yoffset = tailPosition.y;
    
    for (int i = 1; i < self.particleCount; i++) {
        yoffset += index == 1 ? -distanceBetweenPoints : distanceBetweenPoints;
        
        distanceBetweenPoints *= 1.25f;
        
        kmVec3 segmentEndPosition;
        kmVec3Fill(&segmentEndPosition, 0, yoffset, 0);
        
        kmVec3 segmentEndVelocity;
        kmVec3Zero(&segmentEndVelocity);
        
        NVSpringParticle* segmentEnd = [self particleAtIndex: i];
        
        segmentEnd->position = segmentEndPosition;
        segmentEnd->velocity = segmentEndVelocity;
    }
}

- (NVSpringParticleAnchor*) anchor {
    if (_slingHasBeenCreated) {
        return [self particleAnchorAtIndex: 0];
    }
    
    return NULL;
}

- (NVSpringParticle*) tail {
    if (_slingHasBeenCreated) {
        return [self particleAtIndex: 0];
    }
    
    return NULL;
}

- (NVSpringParticle*) head {
    if (_slingHasBeenCreated) {
        return [self particleAtIndex: self.particleCount - 1];
    }
    
    return NULL;
}

@end
