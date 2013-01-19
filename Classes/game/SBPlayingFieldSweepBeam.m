//
//  SBPlayingFieldSweepBeam.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBPlayingFieldSweepBeam.h"

#import "NVCameraController.h"
#import "NVTextureCache.h"

#import "SBRenderStates.h"

@implementation SBPlayingFieldSweepBeam

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_sweep_beam;
    }
    return self;
}

- (void) render {
    if (!_controller.isEnabled) {
        return;
    }
    
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    
    kmMat4 world;
    kmMat4Identity(&world);
    
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
    
    static GLfloat const texcoords[] = {
        0, 1,
        0, 0,
        1, 1,
        1, 0
    };
    
    [[NVTextureCache sharedCache] setTextureFromImageNamed: @"particle-beam.png"];
    
    NVColor4f color = _controller.color;
    
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
    
    float const a = 1.0f;
    
    glColor4f(color.red * a, color.green * a, color.blue * a, a);
    
    glPushMatrix();
    {
        kmVec3 currentPosition = _transform.position;
        kmVec3 currentScale = _transform.scale;
        
        glTranslatef(currentPosition.x, currentPosition.y, currentPosition.z);
        glTranslatef(0, _controller.velocity > 0 ? (currentScale.y / 2) : -(currentScale.y / 2), 0);
        
        glScalef(currentScale.x, 0.333f, 1);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    glPopMatrix();
}

@end
