//
//  SBSling.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSling.h"

#import "SBRenderStates.h"
#import "NVCameraController.h"

#define kCircleSegments 32

@implementation SBSling

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_sling;
        
        _circleVertices = malloc((kCircleSegments + 1) * sizeof(NVVertex));
        
        create_circle(_circleVertices, 1, kCircleSegments);  
    }
    return self;
}

- (void) render {
    NVSpringParticle* tail = [_body tail];
    
    if (tail == NULL || _body.particleCount == 0) {
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
    
    NVVertex bodyVertices[_body.particleCount];
    
    for (int i = 0; i < _body.particleCount; i++) {
        NVSpringParticle* particle = [_body particleAtIndex: i];
        
        NVVertex vertex;
        
        vertex.vertex.x = particle->position.x;
        vertex.vertex.y = particle->position.y;
        vertex.vertex.z = particle->position.z;
        
        bodyVertices[i] = vertex;
    }
    
    // body
    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &bodyVertices[0].vertex);
    glColor4f(1,1,1,1);
    glDrawArrays(GL_LINE_STRIP, 0, _body.particleCount);

    // tail
    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &_circleVertices[0].vertex);
    
    glColor4f(1, 1, 1, 1);

    glPushMatrix();
    {
        GLfloat scale = _body.scaleTail;
        
        glTranslatef(tail->position.x, tail->position.y, tail->position.z);
        glScalef(scale, scale, scale);
        glDrawArrays(GL_LINE_STRIP, 0, kCircleSegments + 1);
    }
    glPopMatrix();
}

- (void) dealloc {
    free(_circleVertices);
    
    [super dealloc];
}

@end
