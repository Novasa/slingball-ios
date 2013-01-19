//
//  NVRenderable.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/18/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"

// unsigned long long
typedef struct {
    // LSB
    unsigned int state_func : 32; 
    unsigned int depth : 24;
    unsigned int layer : 6;
    unsigned int transparent : 1;
    unsigned int fullscreen : 1;
    // MSB
} NVRenderableKey;

@interface NVRenderable : NVComponent {
 @private 
    BOOL _isVisible;
    
    unsigned long long _key;
}

@property(nonatomic, readwrite, assign) BOOL isVisible;

@property(nonatomic, readwrite, assign) unsigned int state;
@property(nonatomic, readwrite, assign) float depth;
@property(nonatomic, readwrite, assign) NSUInteger layer;
@property(nonatomic, readwrite, assign) BOOL isOpaque;
@property(nonatomic, readwrite, assign) BOOL isFullscreen;

@property(nonatomic, readonly) unsigned long long key;

- (void) didChangeVisibility;
- (void) render;

@end
