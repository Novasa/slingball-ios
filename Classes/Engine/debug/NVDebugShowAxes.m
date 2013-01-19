//
//  NVDebugShowAxes.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVDebugShowAxes.h"

#import "NVCamera.h"
#import "NVCameraController.h"
#import "vector_font.h"

#import "NVDebugRenderStates.h"

@implementation NVDebugShowAxes

@synthesize shouldDisplayAxesNames = _shouldDisplayAxesNames;

- (id) init {
    if (self = [super init]) {
        _shouldDisplayAxesNames = YES;
        
        self.layer = 999;
        self.state = (unsigned int)(void*)state_debug;
    }
    return self;
}

- (void) render {
    static const GLfloat lineX[] = {
        0, 0, 0,
        1, 0, 0
    };
    static const GLfloat lineY[] = {
        0, 0, 0,
        0, 1, 0
    };
    static const GLfloat lineZ[] = {
        0, 0, 0,
        0, 0, 1
    };
    
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    
    kmMat4 view;
    
    view = [[NVCameraController sharedController] camera].view;
    
    kmMat4 modelview;
    kmMat4 world = _transform.world;
    
    kmMat4Multiply(&modelview, &view, &world);
    
    glLoadMatrixf(modelview.mat);
    
    glColor4f(1,0,0,1);  
    glVertexPointer(3, GL_FLOAT, 0, lineX);
    glDrawArrays(GL_LINES, 0, 2);
    
    glColor4f(0,1,0,1);
    glVertexPointer(3, GL_FLOAT, 0, lineY);
    glDrawArrays(GL_LINES, 0, 2);
    
    glColor4f(0,0,1,1);
    glVertexPointer(3, GL_FLOAT, 0, lineZ);
    glDrawArrays(GL_LINES, 0, 2);
    
    if (_shouldDisplayAxesNames) {
        GLfloat model[16];
        
        kmMat4 faceScreen;
        
        glPushMatrix();
        {
            glTranslatef(1.1f, 0, 0);
            
            glGetFloatv(GL_MODELVIEW_MATRIX, model);
            
            billboard(&faceScreen, model);
            
            glMultMatrixf(faceScreen.mat);
            glScalef(0.05f, 0.05f, 0.05f);
            
            glColor4f(1,0,0,1);
            
            render_text("X");
        }
        glPopMatrix();
        
        glPushMatrix();
        {
            glTranslatef(0, 1.1f, 0);
            
            glGetFloatv(GL_MODELVIEW_MATRIX, model);
            
            billboard(&faceScreen, model);
            
            glMultMatrixf(faceScreen.mat);
            glScalef(0.05f, 0.05f, 0.05f);
            
            glColor4f(0,1,0,1);
            
            render_text("Y");
        }
        glPopMatrix();
        
        glPushMatrix();
        {
            glTranslatef(0, 0, 1.1f);
            
            glGetFloatv(GL_MODELVIEW_MATRIX, model);
            
            billboard(&faceScreen, model);
            
            glMultMatrixf(faceScreen.mat);
            glScalef(0.05f, 0.05f, 0.05f);
            
            glColor4f(0,0,1,1);
            
            render_text("Z");
        }
        glPopMatrix();
    }
}

@end
