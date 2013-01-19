//
//  NVRenderable.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/18/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVRenderable.h"

@implementation NVRenderable

@dynamic isVisible;

@dynamic isOpaque;
@dynamic isFullscreen;
@dynamic depth;
@dynamic layer;

@synthesize key = _key;

- (id) init {
    if (self = [super init]) {
        _isVisible = YES;

        _key = 0;
        
        NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
        
        renderable_key->state_func = 0;
        renderable_key->depth = 0;
        renderable_key->layer = 0;
        renderable_key->transparent = 0;
        renderable_key->fullscreen = 0;
    }
    return self;
}

- (void) didChangeVisibility { }

- (void) render { }

- (BOOL) isVisible {
	return _isVisible;
}

- (void) setIsVisible: (BOOL) value {
	if (_isVisible != value) {
		_isVisible = value;
        
        [self didChangeVisibility];
	}
}

- (BOOL) isOpaque {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    return !renderable_key->transparent;
}

- (void) setIsOpaque:(BOOL) opaque {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    if (renderable_key->transparent != !opaque) {
        renderable_key->transparent = opaque ? 0 : 1;
        
        [self didChangeVisibility];
    }
}

- (BOOL) isFullscreen {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    return renderable_key->fullscreen;
}

- (void) setIsFullscreen:(BOOL) fullscreen {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    if (renderable_key->fullscreen != fullscreen) {
        renderable_key->fullscreen = fullscreen ? 1 : 0;
    }
}

- (NSUInteger) layer {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    return (NSUInteger)renderable_key->layer;
}

- (void) setLayer:(NSUInteger) layer {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    if (renderable_key->layer != layer) {
        renderable_key->layer = layer;
    }
}

- (float) depth {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    return (float)renderable_key->depth;
}

- (void) setDepth:(float) depth {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    if (renderable_key->depth != depth) {
        renderable_key->depth = depth;
    }
}

- (unsigned int) state {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    return (unsigned int)renderable_key->state_func;
}

- (void) setState:(unsigned int) state {
    NVRenderableKey* renderable_key = (NVRenderableKey*)&_key;
    
    if (renderable_key->state_func != state) {
        renderable_key->state_func = state;
    }
}

@end
