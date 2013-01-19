//
//  SBSplashParticles.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSplashParticles.h"
#import "SBRenderStates.h"

#import "NVCameraController.h"

@implementation SBSplashParticles

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_splash_particles;
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
    
    static GLfloat const vertices[] = {
        -0.5f, -0.5f, 0,
        0, 0.5f, 0,
        0.5f, -0.5f, 0
    };
    
    static GLfloat const normal[] = {
        0, 0, 1
    };
    
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glNormalPointer(GL_FLOAT, 0, normal);
    
    for (int i = 0; i < kMaxSplashParticles; i++) {
        SBSplashParticle* particle = [_controller particleAtIndex: i];
        
        glPushMatrix();
        {
            kmVec3 position = particle->position;
            
            glTranslatef(position.x, position.y, position.z);
            
            glRotatef(particle->angleRotationX, 1, 0, 0);
            glRotatef(particle->angleRotationY, 0, 1, 0);
            glRotatef(particle->angleRotationZ, 0, 0, 1);
            
            glScalef(particle->scale, particle->scale, particle->scale);
        
            float alpha = 1 - (1 - position.z); // 1 - position.z
            
            if (alpha < 0.5f) {
                alpha = 0.5f;
            }
            
            glColor4f(1, 1, 1, alpha);

            glDrawArrays(GL_TRIANGLES, 0, 3);
        }
        glPopMatrix();
    }
}

@end
