//
//  NVCamera.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/19/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVCamera.h"

@implementation NVCamera

@synthesize aspectRatio = _ar;
@synthesize fieldOfView = _fov;
@synthesize near = _near;
@synthesize far = _far;

@dynamic view;
@dynamic projection;

@dynamic clearColor;
@dynamic clearDepth;

- (id) init {
    if (self = [super init]) {
        _view = malloc(sizeof(kmMat4));
        _projection = malloc(sizeof(kmMat4));
        
        _near = 0.1f;
        _far = 100.0f;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        _ar = (float)screenSize.width / (float)screenSize.height;
        _fov = kmRadiansToDegrees(M_PI_4);
        
        _clearColor = malloc(sizeof(NVColor4f));
        _clearDepth = 1.0f;
        
        NVColor4fFill(_clearColor, 0, 0, 0, 1);
        
        glClearColor(_clearColor->red, 
                     _clearColor->green, 
                     _clearColor->blue, 1.0f);
        glClearDepthf(_clearDepth);
    }
    return self;
}

- (void) start {
    [super start];
    
    [self construct];
}

- (void) construct { 
    kmMat4PerspectiveProjection(_projection, _fov, _ar, _near, _far);
    kmMat4Identity(_view);
}

- (kmMat4) view {
    kmMat4 view;
    
    kmMat4Assign(&view, _view);
    
    return view;
}

- (kmMat4) projection {
    kmMat4 projection;
    
    kmMat4Assign(&projection, _projection);
    
    return projection;
}

- (NVColor4f) clearColor {
    NVColor4f color;
    NVColor4fAssign(&color, _clearColor);
    
    return color;
}

- (void) setClearColor: (NVColor4f) color {
    NVColor4fAssign(_clearColor, &color);
    
    glClearColor(_clearColor->red, 
                 _clearColor->green, 
                 _clearColor->blue, 1.0f);
}

- (float) clearDepth {
    return _clearDepth;
}

- (void) setClearDepth: (float) clearDepth {
    if (_clearDepth != clearDepth) {
        _clearDepth = clearDepth;
        
        glClearDepthf(_clearDepth);
    }
}

- (kmVec3) screenLocationFromWorldPoint: (kmVec3) point {
    kmVec3 p;
    return p;
}

- (kmVec3) worldPointFromScreenLocation: (kmVec3) location {
    kmVec3 p;
    return p;
}

- (NVRay) rayFromScreenLocation: (CGPoint) location {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    GLint view[4] = { 
        0, 0, screenSize.width, screenSize.height 
    };
    
    NVRay ray;
    
    create_ray_from_screen_location(&ray, location.x, location.y, _view->mat, _projection->mat, view);
    
    return ray;
}

- (void) dealloc {
    free(_view);
    free(_projection);
    
    free(_clearColor);
    
    [super dealloc];
}

@end
