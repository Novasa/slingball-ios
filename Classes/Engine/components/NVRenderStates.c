/*
 *  NVRenderStates.c
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 2/21/10.
 *  Copyright 2010 Novasa Interactive. All rights reserved.
 *
 */

#include "NVRenderStates.h"

void state_ui(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_BLEND);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
        glDisable(GL_BLEND);
        glDisable(GL_TEXTURE_2D);
    }
}

void state_fullscreen_rectangle(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        glEnable(GL_BLEND);
        
        glCullFace(GL_BACK);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glShadeModel(GL_SMOOTH);
        
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
        glDisable(GL_BLEND);
    }
}

void state_screenspaced_rectangle(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        
        glCullFace(GL_BACK);
        
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
    }    
}
