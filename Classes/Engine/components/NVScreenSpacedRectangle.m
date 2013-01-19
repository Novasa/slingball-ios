//
//  NVScreenSpacedRectangle.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVScreenSpacedRectangle.h"

#import "NVRenderStates.h"

@implementation NVScreenSpacedRectangle

@synthesize rect = _rect;
@synthesize color = _color;

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = NO;
        self.isFullscreen = YES;
        self.state = (unsigned int)(void*)state_screenspaced_rectangle;
        
        _rect = malloc(sizeof(NVRect));
        _color = malloc(sizeof(NVColor4f));
        
        NVRectFill(_rect, 0, 0, 0, 0);
        NVColor4fFill(_color, 1, 1, 1, 1);
    }
    return self;
}

- (void) render {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0, screenSize.width, 0, screenSize.height, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
 
    GLfloat width = _rect->width;
    GLfloat height = _rect->height;

    GLfloat x = _rect->x;
    GLfloat y = _rect->y;

    GLfloat vertices[] = {
        x, y + height,
        x, y,
        x + width, y + height,
        x + width, y
    };
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    
    glColor4f(_color->red, 
              _color->green, 
              _color->blue, 
              _color->alpha);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void) dealloc {
    free(_rect);
    
    [super dealloc];
}

@end
