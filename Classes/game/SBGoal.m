//
//  SBGoal.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/5/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBGoal.h"

#import "SBRenderStates.h"
#import "NVCameraController.h"

@implementation SBGoal

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_goal;
    }
    return self;
}

- (void) render {
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

    NVVertex vertices[_body.particleCount];
    
    for (int i = 0; i < _body.particleCount; i++) {
        NVSpringParticle* particle = [_body particleAtIndex: i];
        
        NVVertex vertex;
        
        vertex.vertex.x = particle->position.x;
        vertex.vertex.y = particle->position.y;
        vertex.vertex.z = particle->position.z;
        
        vertices[i] = vertex;
    }
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &vertices[0].vertex);
    glColor4f(1,1,1,1);
    glDrawArrays(GL_LINE_STRIP, 0, _body.particleCount);
}

@end
