//
//  SBPlayingField.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBPlayingField.h"

#import "SBRenderStates.h"

#import "NVCameraController.h"

@implementation SBPlayingField

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_playing_field;
    }
    return self;
}

- (void) render {
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    kmMat4 world;// = _transform.world;
    kmMat4Identity(&world);
    
    kmMat4 modelview;
    kmMat4Multiply(&modelview, &view, &world);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(modelview.mat);
    
    GLfloat w = _controller.height / 2;
    GLfloat d = _controller.width / 2;
    
    GLfloat goalDepth = _controller.goalWidth;
    GLfloat goalWidth = _controller.goalHeight;
    
    GLfloat gd = goalDepth / 2;
    GLfloat gw = goalWidth / 2;
    
    GLfloat const leftBoundaryVertices[] = {
        -gd, w, 
        -d, w,
        -d, -w,
        -gd, -w
    };
    
    GLfloat const middleVertices[] = {
        -d, 0,
        d, 0
    };
    
    GLfloat const playerOneGoalVertices[] = {
        -gd, -w,
        -gd, -w + gw,
        gd, -w + gw,
        gd, -w
    };
    
    GLfloat const playerTwoGoalVertices[] = {
        -gd, w,
        -gd, w - gw,
        gd, w - gw,
        gd, w
    };
    
    glColor4f(1, 1, 1, 1);
    
    glVertexPointer(2, GL_FLOAT, 0, middleVertices);
    glDrawArrays(GL_LINE_STRIP, 0, 2);

    glVertexPointer(2, GL_FLOAT, 0, playerOneGoalVertices);
    glDrawArrays(GL_LINE_STRIP, 0, 4);
    
    glVertexPointer(2, GL_FLOAT, 0, playerTwoGoalVertices);
    glDrawArrays(GL_LINE_STRIP, 0, 4);
    
    glPushMatrix();
    {
        glVertexPointer(2, GL_FLOAT, 0, leftBoundaryVertices);
        
        glDrawArrays(GL_LINE_STRIP, 0, 4);   
        glScalef(-1, 1, 1);
        glDrawArrays(GL_LINE_STRIP, 0, 4);  
    }
    glPopMatrix();
}

@end
