/*
 *  SBRenderStates.c
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 1/31/10.
 *  Copyright 2010 Novasa Interactive. All rights reserved.
 *
 */

#include "SBRenderStates.h"

static GLfloat const lightBallDiffuse[] = { 
    1, 1, 1, 0.0f
};

static GLfloat const lightDefaultSpecular[] = { 
    1.0f, 1.0f, 1.0f, 1.0f
};

static GLfloat const lightDefaultAmbient[] = { 
    0.0f, 0.0f, 0.0f, 1.0f
};

void state_loading_indicator(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        
        glShadeModel(GL_FLAT);
        
        glDisable(GL_DEPTH_TEST);  
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
    }  
}

void state_splash(bool enabled) {
    if (enabled) {
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
    } else {
        
    }
}

void state_splash_logo(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_BLEND);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBlendFunc(GL_DST_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
        glDisable(GL_BLEND);
        glDisable(GL_TEXTURE_2D);
    }
}

void state_splash_particles(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_BLEND);
        
        glDepthFunc(GL_LEQUAL);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        //glBlendFunc(GL_SRC_ALPHA, GL_ONE);
        
        glDisable(GL_CULL_FACE);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);   
        glDisable(GL_BLEND);
        glDisable(GL_DEPTH_TEST);
    }    
}

void state_feathered_grid(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_COLOR_ARRAY);
        glEnable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        
        glDepthFunc(GL_LEQUAL);
        glCullFace(GL_BACK);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glShadeModel(GL_SMOOTH);

        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_COLOR_ARRAY);
        glDisable(GL_BLEND);
        glDisable(GL_DEPTH_TEST);
    }
}

void state_glowing_box(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnableClientState(GL_COLOR_ARRAY);
        glEnable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        
        glDepthFunc(GL_LEQUAL);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE/*_MINUS_SRC_ALPHA*/);
        glShadeModel(GL_SMOOTH);
        
        glDisable(GL_CULL_FACE);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_COLOR_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_BLEND);
    }    
}

void state_playing_field(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        
        glCullFace(GL_BACK);
        glShadeModel(GL_FLAT);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
    }
}

void state_score_board(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        
        glShadeModel(GL_FLAT);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        //glDisable(GL_CULL_FACE);
    }
}

void state_ball(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnable(GL_COLOR_MATERIAL);
        //glEnable(GL_COLOR_MATERIAL);
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_LIGHTING);
        glEnable(GL_LIGHT0);
        
        glDepthFunc(GL_LEQUAL);
        glCullFace(GL_BACK);
        glShadeModel(GL_FLAT);
        glLightfv(GL_LIGHT0, GL_DIFFUSE, lightBallDiffuse);
        glLightfv(GL_LIGHT0, GL_AMBIENT, lightDefaultAmbient);
        glLightfv(GL_LIGHT0, GL_SPECULAR, lightDefaultSpecular);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisable(GL_COLOR_MATERIAL);
        glDisable(GL_CULL_FACE);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
        glDisable(GL_LIGHT0);
    }
}

void state_ball_outer_rings(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);        
        
        glDepthFunc(GL_LEQUAL);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glShadeModel(GL_FLAT);
        
        glDisable(GL_LIGHTING);
        glDisable(GL_CULL_FACE);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_BLEND);
        glDisable(GL_DEPTH_TEST);  
    }
}

void state_ball_trail(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        glEnable(GL_BLEND);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glCullFace(GL_BACK);
        glShadeModel(GL_FLAT);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
        glDisable(GL_BLEND);
    }  
}

void state_sling(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        
        glDepthFunc(GL_LEQUAL);
        glCullFace(GL_BACK);
        glShadeModel(GL_FLAT);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
        glDisable(GL_DEPTH_TEST);
    }    
}

void state_sling_head(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnable(GL_COLOR_MATERIAL);
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_LIGHTING);
        glEnable(GL_LIGHT0);
        
        glDepthFunc(GL_LEQUAL);
        glCullFace(GL_BACK);
        glShadeModel(GL_FLAT);
        //glLightfv(GL_LIGHT0, GL_DIFFUSE, lightSlingHeadDiffuse);
        glLightfv(GL_LIGHT0, GL_AMBIENT, lightDefaultAmbient);
        glLightfv(GL_LIGHT0, GL_SPECULAR, lightDefaultSpecular);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisable(GL_COLOR_MATERIAL);
        glDisable(GL_CULL_FACE);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
        glDisable(GL_LIGHT0);
    }
}

void state_sling_ribbon(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_COLOR_ARRAY);
        glEnable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        
        glDepthFunc(GL_LEQUAL);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE/*_MINUS_SRC_ALPHA*/);
        glShadeModel(GL_SMOOTH);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_COLOR_ARRAY);
        glDisable(GL_BLEND);
        glDisable(GL_DEPTH_TEST);
    }  
}

void state_sling_idle_pulse(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        glEnable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glCullFace(GL_BACK);
        glShadeModel(GL_FLAT);
        glDepthFunc(GL_LEQUAL);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
        glDisable(GL_BLEND);
        glDisable(GL_DEPTH_TEST);
    }    
}

void state_collision_particles(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        glEnable(GL_BLEND);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE/*_MINUS_SRC_ALPHA*/);
        glCullFace(GL_BACK);
        glShadeModel(GL_FLAT);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
        glDisable(GL_BLEND);
    }   
}

void state_goal(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        
        glDepthFunc(GL_LEQUAL);
        glCullFace(GL_BACK);
        glShadeModel(GL_FLAT);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
        glDisable(GL_DEPTH_TEST);
    }    
}

void state_scanlines(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_BLEND);
        glEnable(GL_CULL_FACE);
        
        glCullFace(GL_BACK);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glShadeModel(GL_FLAT);
        
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_BLEND);
        glDisable(GL_CULL_FACE);
    }
}
/*
void state_floating_text(bool enabled) {
    if (enabled) {
        glEnable(GL_BLEND);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);        
        glShadeModel(GL_FLAT);
        
        glDisable(GL_LIGHTING);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
    } else {
        glDisable(GL_BLEND);
    }
}
*/
void state_floating_text(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        
        glDepthFunc(GL_LEQUAL);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE);
        glShadeModel(GL_SMOOTH);
        
        glDisable(GL_CULL_FACE);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_BLEND);
    }       
}

void state_ball_explosion(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        //glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_POINT_SPRITE_OES);  
        glEnable(GL_BLEND);
        
        glShadeModel(GL_SMOOTH);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE);
        
        glTexEnvi(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        //glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
        glDisable(GL_TEXTURE_2D);
        glDisable(GL_POINT_SPRITE_OES);
        glDisable(GL_BLEND);	        
    }
}

void state_dimmed_overlay(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnable(GL_CULL_FACE);
        glEnable(GL_BLEND);
        
        glCullFace(GL_BACK);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        //glBlendFunc(GL_DST_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glShadeModel(GL_SMOOTH);
        
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_CULL_FACE);
        glDisable(GL_BLEND);
    }
}

void state_instructions(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        
        glDepthFunc(GL_LEQUAL);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_BLEND);
        glDisable(GL_TEXTURE_2D);
    }
}

void state_sweep_beam(bool enabled) {
    if (enabled) {
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_BLEND);
        
        //glBlendFunc(GL_SRC_ALPHA, GL_ONE/*_MINUS_SRC_ALPHA*/);
        //glBlendFunc(GL_DST_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE);
        
        glDisable(GL_LIGHTING);
    } else {
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
        glDisable(GL_BLEND);
        glDisable(GL_TEXTURE_2D);
    }
}
