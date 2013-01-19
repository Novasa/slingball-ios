/*
 *  NVRenderStates.h
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 2/21/10.
 *  Copyright 2010 Novasa Interactive. All rights reserved.
 *
 */

#include <stdbool.h>

#import <OpenGLES/ES1/gl.h>

void state_fullscreen_rectangle(bool enabled);
void state_screenspaced_rectangle(bool enabled);
void state_ui(bool enabled);
