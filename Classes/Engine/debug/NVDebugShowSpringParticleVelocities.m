//
//  NVDebugShowSpringParticleVelocities.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/2/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVDebugShowSpringParticleVelocities.h"

#import "NVCameraController.h"
#import "NVDebugRenderStates.h"

@implementation NVDebugShowSpringParticleVelocities

- (id) init {
    if (self = [super init]) {
        self.layer = 999;
        self.state = (unsigned int)(void*)state_debug;
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
    
    NSUInteger lines = _springBody.particleCount;
    
    NVVertex vertices[lines * 2];
    
    int i = 0;
    for (int j = 0;  j < lines * 2; j += 2) {
        NVSpringParticle* particle = [_springBody particleAtIndex: i];
        
        NVVertex start;
        NVVertex end;
        
        kmVec3Assign(&start.vertex, &particle->position);
        
        kmVec3 direction;
        
        float length = 0.2f;
        
        if (kmVec3LengthSq(&particle->velocity) > kmEpsilon) {
            kmVec3Normalize(&direction, &particle->velocity);
            kmVec3Scale(&direction, &direction, length + kmVec3LengthSq(&particle->velocity));
        } else {
            kmVec3Zero(&direction);
        }
        
        kmVec3Assign(&end.vertex, kmVec3Add(&end.vertex, &start.vertex, &direction));
        
        vertices[j] = start;
        vertices[j + 1] = end;
        
        i++;
    }

    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &vertices[0].vertex);
    
    glColor4f(1,1,0,1);
    glDrawArrays(GL_LINES, 0, lines * 2);
}

@end
