/*
 *  NVDebug.h
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 12/21/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

#import "NVDebugService.h"
#import "NVDebugRenderStates.h"
#import "NVDebugShowFPS.h"
#import "NVDebugShowAxes.h"
#import "NVDebugShowDirection.h"
#import "NVDebugShowSpringParticleVelocities.h"

static inline void kmMat4Print(kmMat4* m) {
    printf("{ %4.f, %4.f, %4.f, %4.f\n",   m->mat[0], m->mat[4], m->mat[8], m->mat[12]);
    printf("  %4.f, %4.f, %4.f, %4.f\n",   m->mat[1], m->mat[5], m->mat[9], m->mat[13]);
    printf("  %4.f, %4.f, %4.f, %4.f\n",   m->mat[2], m->mat[6], m->mat[10], m->mat[14]);
    printf("  %4.f, %4.f, %4.f, %4.f }\n", m->mat[3], m->mat[7], m->mat[11], m->mat[15]);
}

static inline void kmVec3Print(kmVec3* vec) {
    printf("{ X: %4.f, Y: %4.f, Z: %4.f }\n", vec->x, vec->y, vec->z);
}
