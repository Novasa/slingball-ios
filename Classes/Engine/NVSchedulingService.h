//
//  NVSchedulingService.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/17/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVInterpolator.h"
#import "NVComponentDatabaseService.h"

@interface NVSchedulingService : NSObject <NVComponentDatabaseService> {
 @private
    NSMutableArray* _updateables;
        
    float t;
	float before; 
	float elapsed;
	float accumulated;
    
    SEL step_func_selector;
    SEL update_func_selector;
    
    NSMutableArray* _interpolatorPool;
    NSMutableArray* _interpolators;
    NSUInteger _interpolatorCapacity;
}

- (void) tick;

- (NVInterpolator*) nextAvailableInterpolator;
- (void) attachInterpolator: (NVInterpolator*) interpolator;

@end
