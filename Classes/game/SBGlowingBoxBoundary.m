//
//  SBGlowingBoxBoundary.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/10/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBGlowingBoxBoundary.h"
#import "SBRenderStates.h"

#import "NVCameraController.h"

#import "glow_box.h"

@implementation SBGlowingBoxBoundary

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_glowing_box;
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
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVColoredNormalVertex), &GlowBoxVertexData[0].vertex);
    glNormalPointer(GL_FLOAT, sizeof(NVColoredNormalVertex), &GlowBoxVertexData[0].normal);
    glColorPointer(4, GL_FLOAT, sizeof(NVColoredNormalVertex), &GlowBoxVertexData[0].color);
    
    glDrawArrays(GL_TRIANGLES, 0, kGlowBoxNumberOfVertices);
}

@end
