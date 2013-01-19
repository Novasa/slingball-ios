//
//  SBSplash.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//
/*
#import "SBSplash.h"

#import "vector_font.h"

#import "SBRenderStates.h"
#import "NVCameraController.h"

@implementation SBSplash

- (id) init {
    if (self = [super init]) {
        self.layer = 2;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_splash;
    }
    return self;
}

- (void) renderPressAnyKey {
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    const char* text = "ANY TOUCH TO CONTINUE";
    
    GLfloat scale = 0.05f;
    GLfloat const width = get_width_of_text(text) * scale;
    
    glPushMatrix();
    {
        glTranslatef(-(width / 2), -1.5f, 0);
        glScalef(scale, scale, scale);
        
        NVColor4f clearColor = cam.clearColor;
        
        glColor4f(clearColor.red, clearColor.green, clearColor.blue, 1);
        
        render_text(text);
    }
    glPopMatrix();    
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
    
    [self renderPressAnyKey];
}

@end
*/