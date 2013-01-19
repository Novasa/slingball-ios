//
//  SBFeatheredGrid.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/7/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBFeatheredGrid.h"

#import "SBRenderStates.h"
#import "NVCameraController.h"

// TODO: very optimizable: store all vertices in memory rather than drawing one line at a time

@implementation SBFeatheredGrid

- (id) init {
    if (self = [super init]) {
        self.layer = 0;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_feathered_grid;
        
        _lines = kFeatheredGridLines;
        _lineSpacing = 0.05f;
        /*
        GLfloat height = _lines * _lineSpacing;
        GLfloat yorigin = height / 2;
        
        NSUInteger j = 0;
        for (int i = 0; i < _lines; i += 3) {
            GLfloat yoffset = j++ * -_lineSpacing;
            
            NVVertex a;
            NVVertex mid;
            NVVertex b;
            
            GLfloat y = yorigin + yoffset;
            
            a.vertex.x = -1;
            a.vertex.y = y;
            a.vertex.z = 0;
            
            mid.vertex.x = 0;
            mid.vertex.y = y;
            mid.vertex.z = 0;            
            
            b.vertex.x = 1;
            b.vertex.y = y;
            b.vertex.z = 0;
            
            _horizontalVertices[i] = a;
            _horizontalVertices[i + 1] = mid;
            _horizontalVertices[i + 2] = b;
        }*/
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
    /*
    static GLfloat const colors[] = {
        1, 1, 1, 0,
        1, 1, 1, 0.1f,
        1, 1, 1, 0
    };
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &_horizontalVertices[0].vertex);
    glColorPointer(4, GL_FLOAT, 0, colors);
    
    glDrawArrays(GL_LINE_STRIP, 0, kFeatheredGridLines * 3);*/
    
    static GLfloat const horizontalVertices[] = {
        -1, 0, 
        0, 0,
        1, 0,
    };

    static GLfloat const verticalVertices[] = {
        0, 1, 
        0, 0,
        0, -1,
    };
    
    static GLfloat const colors[] = {
        1, 1, 1, 0,
        1, 1, 1, 0.1f,
        1, 1, 1, 0
    };
    
    glVertexPointer(2, GL_FLOAT, 0, horizontalVertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    
    GLfloat width = _lines * _lineSpacing;
    GLfloat height = _lines * _lineSpacing;
    
    glPushMatrix();
    {
        glTranslatef(0, height / 2, 0);
        
        for (int i = 0; i < _lines; i++) {
            glDrawArrays(GL_LINE_STRIP, 0, 3);
            
            glTranslatef(0, -_lineSpacing, 0);
        }
    }
    glPopMatrix();
    
    glVertexPointer(2, GL_FLOAT, 0, verticalVertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    
    glPushMatrix();
    {
        glTranslatef(-(width / 2), 0, 0);
        
        for (int i = 0; i < _lines; i++) {
            glDrawArrays(GL_LINE_STRIP, 0, 3);
            
            glTranslatef(_lineSpacing, 0, 0);
        }
    }
    glPopMatrix();
}

@end
