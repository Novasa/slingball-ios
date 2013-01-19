//
//  SBSlingIdlePulse.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingIdlePulse.h"

#import "SBRenderStates.h"
#import "SBSlingIdlePulseController.h"

#import "NVCameraController.h"

#define kIdlePulseSegments 32

@implementation SBSlingIdlePulse

- (id) init {
    if (self = [super init]) {
        _vertices = malloc((kIdlePulseSegments + 1) * sizeof(NVVertex));
        
        create_circle(_vertices, 1, kIdlePulseSegments);        
        
        self.layer = 1;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_sling_idle_pulse;
    }
    return self;
}

- (void) render {
    NVSpringParticle* tail = [_body tail];
    
    if (tail == NULL) {
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
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &_vertices[0].vertex);
    
    glColor4f(1,1,1, 1 - (_idleController.scale / _idleController.maxScale));
    
    glPushMatrix();
    {
        GLfloat finalScale = _body.scaleTail + _idleController.scale;
        
        glTranslatef(tail->position.x, tail->position.y, tail->position.z);
        glScalef(finalScale, finalScale, finalScale);
        
        glDrawArrays(GL_LINE_STRIP, 0, kIdlePulseSegments + 1);
    }
    glPopMatrix();
}

- (void) dealloc {
    free(_vertices);
    
    [super dealloc];
}

@end
