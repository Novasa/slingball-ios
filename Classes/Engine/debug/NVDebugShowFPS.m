//
//  NVDebugShowFPS.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/21/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVDebugShowFPS.h"

#import "NVDebugRenderStates.h"
#import "NVES1Renderer.h"
#import "vector_font.h"

@implementation NVDebugShowFPS

- (id) init {
    if (self = [super init]) {
        self.isFullscreen = YES;
        self.state = (unsigned int)(void*)state_debug;
    }
    return self;
}

- (void) render {
#ifdef DEBUG
    const char* text = [[NSString stringWithFormat: @"%.0f", [NVES1Renderer debug_framesPerSecond]] 
                        cStringUsingEncoding: [NSString defaultCStringEncoding]];
    
    GLfloat scale = 5;
    
    GLfloat height = get_height_of_text(text) * scale;
    GLfloat width = get_width_of_text(text) * scale;
    GLfloat padding = 4;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0, screenSize.width, 0, screenSize.height, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glTranslatef(screenSize.width - width - padding, height, 0);
    glScalef(scale, scale, scale);
    
    glColor4f(1, 1, 0, 1);

    render_text(text);
#endif
}

@end
