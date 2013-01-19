//
//  SBSlingIdlePulseController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "SBSlingController.h"

@class SBSlingIdlePulse;

@interface SBSlingIdlePulseController : NVSchedulable {
 @private
    REQUIRES(SBSlingController, _slingController);
    
    // not marked as a dependency due to circular referencing (it would be no problem
    // if we just bound either this, or the renderable), since the injections would then
    // happen appropriately, but in this case we're manually binding both, so the order
    // has consequences
    SBSlingIdlePulse* _idlePulse;
    
    float _scale;
    float _maxScale;
    
    float _speed;
    
    float _timeTailWasReleased;
    BOOL _tailWasReleased;
    
    float _durationUntilConsideredIdle;
    float _timePassedSinceTailWasReleased;
    
    BOOL _isIdle;
}

@property(nonatomic, readonly) float scale;
@property(nonatomic, readonly) float maxScale;

@end
