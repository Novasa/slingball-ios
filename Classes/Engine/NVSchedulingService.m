//
//  NVSchedulingService.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/17/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVSchedulingService.h"
#import "NVSchedulable.h"

// TODO: create category for interpolator that adds convenience methods like interpolatorFrom:to:
// which also automatically attaches to scheduling service

@implementation NVSchedulingService

- (id) init {
    if (self = [super init]) {
        _updateables = [[NSMutableArray alloc] init];
        
        elapsed = 0.0f;
        accumulated = 0.0f;
        
        before = current_time();
        
        t = 0.0f;
        
        step_func_selector = @selector(step:delta:);
        update_func_selector = @selector(update:interpolation:);
        
        _interpolators = [[NSMutableArray alloc] init];
        
        _interpolatorCapacity = 10;
        _interpolatorPool = [[NSMutableArray alloc] initWithCapacity: _interpolatorCapacity];
        
        for (NSUInteger i = 0; i < _interpolatorCapacity; i++) {
            NVInterpolator* interpolator = [[NVInterpolator alloc] init];
            
            [_interpolatorPool addObject: interpolator];
            
            [interpolator release];
        }
    }
    return self;
}

- (NVInterpolator*) nextAvailableInterpolator {
    for (NSUInteger i = 0; i < _interpolatorCapacity; i++) {
        NVInterpolator* const interpolator = [_interpolatorPool objectAtIndex: i];
        
        if (!interpolator.isAssigned) {
            return interpolator;
        }
    }
    
    Debug((@"SCHEDULING: Warning - A request for an interpolator was issued, but all interpolators were assigned."));
    
    return nil;
}

- (void) attachInterpolator: (NVInterpolator*) interpolator {
    if (![_interpolators containsObject: interpolator]) {
        [_interpolators addObject: interpolator];
    }
}

- (void) tick {
    static void (*step_func)(id, SEL, float, float) = nil;
    static void (*update_func)(id, SEL, float, float) = nil;

    if (_interpolators.count > 0) {
        for (int i = _interpolators.count - 1; i >= 0; i--) {
            NVInterpolator* const interpolator = [_interpolators objectAtIndex: i];
            
            if (interpolator.hasEnded) {
                [_interpolators removeObjectAtIndex: i];
            }
        }
    }
    
    float const now = current_time();
	float const dt = now - before;

	before = now;

	accumulated += dt;
	elapsed += dt;

    static float const step = FIXED_TIME_STEP;

	while (accumulated >= step) {
        float const timeScaleAdjustedDeltaTime = step * GLOBAL_TIME_SCALE;
        
        if (_interpolators.count > 0) {
            for (NSUInteger i = 0; i < _interpolators.count; i++) {
                NVInterpolator* const interpolator = [_interpolators objectAtIndex: i];
                
                if (interpolator.isAssigned) {
                    [interpolator stepWithDeltaTime: timeScaleAdjustedDeltaTime];
                }            
            }
        }
        
        for (NSUInteger i = 0; i < _interpolatorCapacity; i++) {
            NVInterpolator* const interpolator = [_interpolatorPool objectAtIndex: i];
            
            if (interpolator.isAssigned) {
                [interpolator stepWithDeltaTime: timeScaleAdjustedDeltaTime];
            }
        }
        
        for (NSUInteger i = 0; i < _updateables.count; i++) {
            NVSchedulable* const updateable = [_updateables objectAtIndex: i];
            
            if (updateable.isEnabled) {
                step_func = (void(*)(id, SEL, float, float))[updateable methodForSelector: step_func_selector];
                step_func(updateable, step_func_selector, t, timeScaleAdjustedDeltaTime);
            }
        }
        
		t += step;
		accumulated -= step;
	}
	
	float const alpha = accumulated / step;

    for (NSUInteger i = 0; i < _updateables.count; i++) {
        NVSchedulable* const updateable = [_updateables objectAtIndex: i];
        
        if (updateable.isEnabled) {
            update_func = (void(*)(id, SEL, float, float))[updateable methodForSelector: update_func_selector];
            update_func(updateable, update_func_selector, elapsed, alpha);
        }
    }
}

- (BOOL) isInterestedInComponent: (NVComponent*) component {
    if ([component isKindOfClass: [NVSchedulable class]]) {
        return YES;
    }
    
    return NO;
}

- (void) database: (NVComponentDatabase*) database didBind: (NVComponent*) component {
    @synchronized(_updateables) {
        if (![_updateables containsObject: component]) {
            [_updateables addObject: component];
        }
    }
}

- (void) database: (NVComponentDatabase*) database didUnbind: (NVComponent*) component {
    @synchronized(_updateables) {
        if ([_updateables containsObject: component]) {
            [_updateables removeObject: component];
        }
    }
}

- (void) dealloc {
    if (_updateables != nil) {
        [_updateables release];
        _updateables = nil;
    }
    
    [_interpolators release];
    [_interpolatorPool release];
    
    [super dealloc];
}

@end
