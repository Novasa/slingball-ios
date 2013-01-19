//
//  NVFullscreenRectangle.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVFullscreenRectangle.h"

#import "NVRenderStates.h"

@implementation NVFullscreenRectangle

@synthesize color = _color;

- (id) init {
    if (self = [super init]) {
        _color = malloc(sizeof(NVColor4f));
    
        NVColor4fFill(_color, 0, 0, 0, 1);
        
        self.isOpaque = YES;
        self.isFullscreen = YES;
        
        self.state = (unsigned int)(void*)state_fullscreen_rectangle;
    }
    return self;
}

- (void) render {
    static GLfloat const vertices[] = {
        -1, -1,
        1, -1,
        -1, 1,
        1, 1,
    };
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-1, 1, -1, 1, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glColor4f(_color->red, 
              _color->green, 
              _color->blue, 
              _color->alpha);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void) dealloc {
    free(_color);
    
    [super dealloc];
}

@end
