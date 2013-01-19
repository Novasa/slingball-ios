//
//  SBSlingBody.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSoftSpringBody.h"

@interface SBSlingBody : NVSoftSpringBody {
 @private
    float _scaleHead;
    float _scaleTail;
    
    BOOL _slingHasBeenCreated;
    
    NSUInteger _playerIndex;
}

@property(nonatomic, readwrite) float scaleHead;
@property(nonatomic, readwrite) float scaleTail;

- (void) createSlingForPlayerIndex: (NSUInteger) index;
- (void) restoreInitialState;
- (void) restoreInitialStateForPlayerIndex: (NSUInteger) index;

- (NVSpringParticle*) tail;
- (NVSpringParticle*) head;
- (NVSpringParticleAnchor*) anchor;

@end
