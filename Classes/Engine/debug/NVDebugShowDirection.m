//
//  NVDebugShowDirection.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVDebugShowDirection.h"

#import "NVCamera.h"
#import "NVCameraController.h"
#import "vector_font.h"

#import "NVDebugRenderStates.h"

@implementation NVDebugShowDirection

- (id) init {
    if (self = [super init]) {
        _direction = malloc(sizeof(kmVec3));
        
        _shouldAlwaysNormalize = YES;
        _shouldDisplayOriginAndDirectionText = YES;
        
        self.layer = 999;
        self.state = (unsigned int)(void*)state_debug;
    }
    return self;
}

@synthesize direction = _direction;

@synthesize shouldAlwaysNormalize = _shouldAlwaysNormalize;
@synthesize shouldDisplayOriginAndDirectionText = _shouldDisplayOriginAndDirectionText;

- (void) render {    
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    
    kmMat4 modelview;
    kmMat4 world = _transform.world;
    
    kmMat4Multiply(&modelview, &view, &world);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(modelview.mat);
    
    kmVec3 normal;
    kmVec3Fill(&normal, _direction->x, _direction->y, _direction->z);
    
    if (_shouldAlwaysNormalize) {
        kmVec3Normalize(&normal, &normal);
    }
    
    GLfloat line[] = {
        0, 0, 0,
        normal.x, normal.y, normal.z
    };
    
    glVertexPointer(3, GL_FLOAT, 0, line);
    glColor4f(1,1,0,1);  
    glDrawArrays(GL_LINES, 0, 2);
    
    if (_shouldDisplayOriginAndDirectionText) {
        GLfloat model[16];
        
        kmMat4 faceScreen;
        
        glPushMatrix();
        {
            glTranslatef(-normal.x * 0.1f, -normal.y * 0.1f, -normal.z * 0.1f);
            
            glGetFloatv(GL_MODELVIEW_MATRIX, model);
            
            billboard(&faceScreen, model);
            
            glMultMatrixf(faceScreen.mat);
            glScalef(0.05f, 0.05f, 0.05f);
            
            render_text("O");
        }
        glPopMatrix();
        
        glPushMatrix();
        {
            glTranslatef(normal.x + 0.1f, normal.y + 0.1f, normal.z + 0.1f);
            
            glGetFloatv(GL_MODELVIEW_MATRIX, model);
            
            billboard(&faceScreen, model);
            
            glMultMatrixf(faceScreen.mat);
            glScalef(0.05f, 0.05f, 0.05f);
            
            render_text("D");
        }
        glPopMatrix();
    }
}

- (void) dealloc {
    free(_direction);
    
    [super dealloc];
}

@end
