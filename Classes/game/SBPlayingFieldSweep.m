//
//  SBPlayingFieldSweep.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBPlayingFieldSweep.h"

#import "NVCameraController.h"

#import "SBRenderStates.h"

@implementation SBPlayingFieldSweep

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_feathered_grid;
    }
    return self;
}

- (void) render {
    if (!_controller.isEnabled) {
        return;
    }
    
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    kmMat4 world = _transform.world;
    
    kmMat4 modelview;
    kmMat4Multiply(&modelview, &view, &world);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(modelview.mat);

    static GLfloat const vertices[] = {
        -0.5f, -0.5f, 0,
        -0.5f, 0.5f, 0,
        0.5f, -0.5f, 0,
        0.5f, 0.5f, 0
    };
    
    NVColor4f color = _controller.color;
    
    float maxAlpha = 0.1f;
    
    GLfloat colors[] = {
        color.red, color.green, color.blue, _controller.velocity > 0 ? 0 : maxAlpha,
        color.red, color.green, color.blue, _controller.velocity > 0 ? maxAlpha : 0,
        color.red, color.green, color.blue, _controller.velocity > 0 ? 0 : maxAlpha,
        color.red, color.green, color.blue, _controller.velocity > 0 ? maxAlpha : 0
    };

    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
