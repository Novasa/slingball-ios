//
//  NVTransformationService.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVTransformationService.h"

#import "NVTransformable.h"

@implementation NVTransformationService

- (id) init {
    if (self = [super init]) {
        _transformables = [[NSMutableArray alloc] init];
        
        resolve_func_selector = @selector(resolve);
    }
    return self;
}

- (void) resolve {
    static void (*resolve_func)(id, SEL) = nil;
    
    for (int i = 0; i < _transformables.count; i++) {
        NVTransformable* const transformable = [_transformables objectAtIndex: i];

        if (transformable.isEnabled) {
            resolve_func = (void(*)(id, SEL))[transformable methodForSelector: resolve_func_selector];
            resolve_func(transformable, resolve_func_selector);
        }
    }
}

- (BOOL) isInterestedInComponent: (NVComponent*) component {
    if ([component isKindOfClass: [NVTransformable class]]) {
        return YES;
    }
    
    return NO;
}

- (void) database: (NVComponentDatabase*) database didBind: (NVComponent*) component {
    @synchronized(_transformables) {
        if (![_transformables containsObject: component]) {
            [_transformables addObject: component];
        }
    }
}

- (void) database: (NVComponentDatabase*) database didUnbind: (NVComponent*) component {
    @synchronized(_transformables) {
        if ([_transformables containsObject: component]) {
            [_transformables removeObject: component];
        }
    }
}

- (void) dealloc {
    if (_transformables != nil) {
        [_transformables release];
        _transformables = nil;
    }
    
    [super dealloc];
}

@end
