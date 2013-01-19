//
//  SBBallExplosionParticles.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/24/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBallExplosionParticles.h"

#import "SBRenderStates.h"

#import "NVCameraController.h"
#import "NVTextureCache.h"

@implementation SBBallExplosionParticles

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_ball_explosion;
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
    
    static GLfloat const vertex[] = {
        0, 0, 0
    };
    
    glVertexPointer(3, GL_FLOAT, 0, vertex);
    
    [[NVTextureCache sharedCache] setTextureFromImageNamed: @"particle.png"];

    for (int i = 0; i < kMaxBallExplosionParticles; i++) {
        SBBallExplosionParticle* particle = [_controller particleAtIndex: i];
        
        float const a = particle->life;
        float const size = 24 * a;
        
        glPointSize(size);
        glColor4f(1 * a, 1 * a, 1 * a, a);
        
        kmVec3 position = particle->position;
        
        glPushMatrix();
        {
            glTranslatef(position.x, position.y, position.z);
            glDrawArrays(GL_POINTS, 0, 1);
        }
        glPopMatrix();
    }
}

@end
