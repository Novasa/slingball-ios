/*
 *  NVDebugRenderStates.c
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 12/20/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

#include "NVDebugRenderStates.h"

void state_debug(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        
        glDisable(GL_DEPTH_TEST);  
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
    }
}
