//
//  SBBall.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBall.h"

#import "SBRenderStates.h"
#import "NVCameraController.h"

#import "kugle.h"

@implementation SBBall

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_ball;
    }
    return self;
}

- (void) render {
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    kmMat4 world = _transform.world;
    
    static GLfloat const lightPosition[] = { 
        0.0f, 0.0f, 1.0f, 0.0f
    };
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glMultMatrixf(view.mat);
    glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
    glMultMatrixf(world.mat); 
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVNormalVertex), &SphereVertexData[0].vertex);
    glNormalPointer(GL_FLOAT, sizeof(NVNormalVertex), &SphereVertexData[0].normal);
    
    GLfloat shade = 0.9f;
    
    glColor4f(shade, shade, shade, 1.0f);
    
    glDrawArrays(GL_TRIANGLES, 0, kSphereNumberOfVertices);
}

@end
