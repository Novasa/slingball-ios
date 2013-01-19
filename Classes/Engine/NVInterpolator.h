//
//  NVInterpolator.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/25/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVInterpolatorDelegate.h"

@interface NVInterpolator : NSObject {
 @private
    float _duration;
    float _timeElapsedSinceStarting;
    
    float _weight;
    
    BOOL _isAssigned;
    BOOL _hasEnded;
    
    id<NVInterpolatorDelegate> _delegate;
    
    SEL _stepSelector;
    SEL _finishSelector;
    
    BOOL _respondsToStepSelector;
    BOOL _respondsToFinishSelector;
}

@property(nonatomic, readwrite, assign) float duration;
@property(nonatomic, readonly) float weight;

@property(nonatomic, readonly) BOOL isAssigned;
@property(nonatomic, readonly) BOOL hasEnded;

@property(nonatomic, readonly) id<NVInterpolatorDelegate> delegate;

- (BOOL) beginWithDelegate: (id<NVInterpolatorDelegate>) delegate;
- (void) stepWithDeltaTime: (float) dt;
- (void) end;

@end
