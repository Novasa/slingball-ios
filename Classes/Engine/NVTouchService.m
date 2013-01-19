//
//  NVTouchService.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVTouchService.h"

@implementation NVTouchService

- (id) init {
    if (self = [super init]) {
        _touchables = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL) isInterestedInComponent: (NVComponent*) component {
    if ([component conformsToProtocol: @protocol(NVTouchable)]) {
        return YES;
    }
    
    return NO;
}

- (void) database: (NVComponentDatabase*) database didBind: (NVComponent*) component {
    @synchronized(_touchables) {
        if (![_touchables containsObject: component]) {
            [_touchables addObject: component];
        }
    }
}

- (void) database: (NVComponentDatabase*) database didUnbind: (NVComponent*) component {
    @synchronized(_touchables) {
        if ([_touchables containsObject: component]) {
            [_touchables removeObject: component];
        }
    }
}

- (void) touchesBegan: (NSSet*) touches {
    SEL callback = @selector(touchesBegan:);
    
    for (int i = 0; i < _touchables.count; i++) {
        id<NVTouchable> const component = [_touchables objectAtIndex: i];
        
        if ([(NVComponent*)component isEnabled]) {            
            if ([component respondsToSelector: callback]) {
                [component performSelector: callback withObject: touches];
            }
        }
    }
}

- (void) touchesMoved: (NSSet*) touches {
    SEL callback = @selector(touchesMoved:);
    
    for (int i = 0; i < _touchables.count; i++) {
        id<NVTouchable> const component = [_touchables objectAtIndex: i];
        
        if ([(NVComponent*)component isEnabled]) {            
            if ([component respondsToSelector: callback]) {
                [component performSelector: callback withObject: touches];
            }
        }
    }
}

- (void) touchesEnded: (NSSet*) touches {
    SEL callback = @selector(touchesEnded:);
    
    for (int i = 0; i < _touchables.count; i++) {
        id<NVTouchable> const component = [_touchables objectAtIndex: i];
        
        if ([(NVComponent*)component isEnabled]) { 
            if ([component respondsToSelector: callback]) {
                [component performSelector: callback withObject: touches];
            }
        }
    }
}

- (void) dealloc {
    if (_touchables != nil) {
        [_touchables release];
        _touchables = nil;
    }
    
    [super dealloc];
}

@end
