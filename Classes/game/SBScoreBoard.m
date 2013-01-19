//
//  SBScoreBoard.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBScoreBoard.h"

#import "NVCameraController.h"

#import "SBRenderStates.h"

#import "vector_font.h"

#define kRingSegments 6

@implementation SBScoreBoard

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_score_board;
        
        _vertices = malloc((kRingSegments + 2) * sizeof(NVVertex));
        
        create_circle(_vertices, 1, kRingSegments); 
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
   
    NSUInteger playerOneScore = [_controller scoreForPlayerIndex: 1];
    NSUInteger playerTwoScore = [_controller scoreForPlayerIndex: 2];
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &_vertices[0].vertex);
    
    GLfloat w = _playingFieldController.height / 2;
    GLfloat d = _playingFieldController.width / 2;
    
    GLfloat radius = 0.175f;
    GLfloat padding = radius;
    
    glColor4f(1, 1, 1, 1);
    
    if (playerOneScore > 0) {
        // player one, bottom
        GLfloat x = d - radius - padding;
        GLfloat y = -w + radius + padding;
        
        for (int i = 0; i < playerOneScore; i++) {
            glPushMatrix();
            {
                glTranslatef(x, y, 0);
                glScalef(radius, radius, radius);
                
                glDrawArrays(GL_TRIANGLE_FAN, 0, kRingSegments + 2);
            }
            glPopMatrix();
            
            x -= radius + padding + (padding / 2);
        }
    }
    
    if (playerTwoScore > 0) {
        // player one, bottom
        GLfloat x = -d + radius + padding;
        GLfloat y = w - radius - padding;
        
        for (int i = 0; i < playerTwoScore; i++) {
            glPushMatrix();
            {
                glTranslatef(x, y, 0);
                glScalef(radius, radius, radius);
                
                glDrawArrays(GL_TRIANGLE_FAN, 0, kRingSegments + 2);
            }
            glPopMatrix();
            
            x += radius + padding + (padding / 2);
        }
    }
}

- (void) dealloc {
    free(_vertices);
    
    [super dealloc];
}

@end
