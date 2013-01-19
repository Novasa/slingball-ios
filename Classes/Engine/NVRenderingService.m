//
//  NVRenderingService.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/10/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVRenderingService.h"
#import "NVRenderable.h"

@implementation NVRenderingService

- (id) init {
    if (self = [super init]) {
        _renderables = [[NSMutableArray alloc] init];

        _sortDescriptorRenderKey = [[NSSortDescriptor alloc] initWithKey: @"key" ascending: YES];
        _sortDescriptors = [[NSArray alloc] initWithObjects: _sortDescriptorRenderKey, nil];
        
        render_func_selector = @selector(render);
        
        _currentlyEnabledState = 0;
    }
    return self;
}

#ifdef DEBUG
- (void) debug_printRenderableOrder {
    for (NSUInteger i = 0; i < _renderables.count; i++) {
        Debug((@"%u: %@", i, [_renderables objectAtIndex: i]));
    }    
}
#endif

- (void) render {
    //static float frameCount = 0;
    //static float const sortAfterFrameAmount = 3;
    
    //if (frameCount == sortAfterFrameAmount) {
      //  frameCount = 0;
   
        [_renderables sortUsingDescriptors: _sortDescriptors];
  
    //}

    //frameCount++;
    
    static void (*render_func)(id, SEL) = nil;
    
    _currentlyEnabledState = 0;
    
    for (NSUInteger i = 0; i < _renderables.count; i++) {
        NVRenderable* renderable = [_renderables objectAtIndex: i];
   
        if (renderable.isVisible) {
            unsigned long long const key = renderable.key;
        
            unsigned int const desired_state = ((NVRenderableKey*)&key)->state_func;

            if (desired_state != 0) {
                if (_currentlyEnabledState != desired_state) {
                    if (_currentlyEnabledState != 0) {
                        void (*state)(bool) = (void*)_currentlyEnabledState;
                        
                        state(false);
                    }
                    
                    void (*state)(bool) = (void*)desired_state;
                    
                    state(true);
                  
                    //DebugVerbosely((@"state changed: %u (%@)", desired_state, renderable));

                    _currentlyEnabledState = desired_state;
                } else {
                    //DebugVerbosely((@"state kept:    %u (%@)", current_state, renderable));
                }
            }
            
            render_func = (void(*)(id, SEL))[renderable methodForSelector: render_func_selector];
            render_func(renderable, render_func_selector);
        }
        
        if (i == _renderables.count - 1) {
            if (_currentlyEnabledState != 0) {
                void (*state)(bool) = (void*)_currentlyEnabledState;
                
                state(false);                    
            }
        }
    }
}

- (BOOL) isInterestedInComponent: (NVComponent*) component {
    if ([component isKindOfClass: [NVRenderable class]]) {
        return YES;
    }
    
    return NO;
}

- (void) database: (NVComponentDatabase*) database didBind: (NVComponent*) component {
    @synchronized(_renderables) {
        if (![_renderables containsObject: component]) {
            [_renderables addObject: component];
        }
    }
}

- (void) database: (NVComponentDatabase*) database didUnbind: (NVComponent*) component {
    @synchronized(_renderables) {
        if ([_renderables containsObject: component]) {            
            [_renderables removeObject: component];
        }
    }
}

- (void) dealloc {
    if (_renderables != nil) {
        [_renderables release];
        _renderables = nil;
    }
    
    if (_sortDescriptorRenderKey != nil) {
        [_sortDescriptorRenderKey release];
        _sortDescriptorRenderKey = nil;
    }
    
    if (_sortDescriptors != nil) {
        [_sortDescriptors release];
        _sortDescriptors = nil;
    }
    
    [super dealloc];
}

@end
