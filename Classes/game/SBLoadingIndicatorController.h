//
//  SBLoadingIndicatorController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/16/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"

@interface SBLoadingIndicatorController : NVSchedulable {
 @private
    float _durationBetweenTicks;
    float _timeElapsedSincePreviousTick;
    
    NSInteger _indices;
    NSInteger _index;
    
    NSInteger _direction;
}

- (NSInteger) indexCount;
- (NSInteger) indexForCurrentFrame;

@end
