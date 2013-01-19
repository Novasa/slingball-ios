//
//  SBInstructions.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/26/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBInstructions.h"

#import "NVCameraController.h"
#import "NVTextureCache.h"

#import "SBRenderStates.h"
#import "SBTextures.h"

@implementation SBInstructions

- (id) init {
    if (self = [super init]) {
        self.layer = 3;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_instructions;
        
        self.isVisible = NO;
    }
    return self;
}

- (void) render {
    [[NVTextureCache sharedCache] setTextureFromImageNamed: @"texpak00.png"];
    
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
        -1, 1, 0,
        -1, -1, 0,
        1, 1, 0,
        1, -1, 0
    };
    
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, instructionsTexCoords);
    
    glColor4f(1, 1, 1, _controller.alpha);
    
    glPushMatrix();
    {
        float textureAspectRatio = instructionsTexWidth / instructionsTexHeight;
        
        float scalex = textureAspectRatio;
        float scaley = 1;
        
        float globalScale = 0.8f;
        
        glScalef(globalScale, globalScale, globalScale);
        glScalef(scalex, scaley, 1);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    glPopMatrix();
}

@end
