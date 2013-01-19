/*
 *  SBRenderStates.h
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 1/31/10.
 *  Copyright 2010 Novasa Interactive. All rights reserved.
 *
 */

#include <stdbool.h>
#include <stdio.h>

#include <OpenGLES/ES1/gl.h>

void state_loading_indicator(bool enabled);
void state_splash(bool enabled);
void state_splash_logo(bool enabled);
void state_splash_particles(bool enabled);
void state_feathered_grid(bool enabled);
void state_playing_field(bool enabled);
void state_score_board(bool enabled);
void state_ball(bool enabled);
void state_ball_outer_rings(bool enabled);
void state_ball_trail(bool enabled);
void state_ball_explosion(bool enabled);
void state_sling(bool enabled);
void state_sling_head(bool enabled);
void state_sling_ribbon(bool enabled);
void state_sling_idle_pulse(bool enabled);
void state_collision_particles(bool enabled);
void state_goal(bool enabled);
//void state_floating_goal_text(bool enabled);
void state_glowing_box(bool enabled);
void state_scanlines(bool enabled);
void state_floating_text(bool enabled);
void state_dimmed_overlay(bool enabled);
void state_instructions(bool enabled);
void state_sweep_beam(bool enabled);
