//
//  SBBallOuterRings.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/10/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBallOuterRings.h"

#import "SBRenderStates.h"
#import "NVCameraController.h"

#define kBallSegments 32

@implementation SBBallOuterRings

- (id) init {
    if (self = [super init]) {
        _vertices = malloc((kBallSegments + 1) * sizeof(NVVertex));
         
        create_circle(_vertices, 1.001f, kBallSegments);        
          
        self.layer = 1;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_ball_outer_rings;
    }
    return self;
}

- (void) render {
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    kmMat4 world = _transform.world;
    
    kmMat4 modelview;
    kmMat4Multiply(&modelview, &view, &world);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(modelview.mat);
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &_vertices[0].vertex);

    glColor4f(1,1,1,0.25f);
    
    glPushMatrix();
    {
        glDrawArrays(GL_LINE_STRIP, 0, kBallSegments + 1);
        glRotatef(45, 1, 0, 0);
        glDrawArrays(GL_LINE_STRIP, 0, kBallSegments + 1);
        glRotatef(45, 1, 0, 0);
        glDrawArrays(GL_LINE_STRIP, 0, kBallSegments + 1);
        glRotatef(45, 1, 0, 0);
        glDrawArrays(GL_LINE_STRIP, 0, kBallSegments + 1);   
    }
    glPopMatrix();
}

- (void) dealloc {
    free(_vertices);
    
    [super dealloc];
}

@end
