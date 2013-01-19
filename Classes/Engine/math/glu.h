/*
 *  glu.h
 *  slingball
 *
 *  Created by Jacob Hansen on 2/14/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

#include <OpenGLES/ES1/gl.h>

#include <stdio.h>
#include <string.h>
#include <math.h>

#define MEMCPY( DST, SRC, BYTES) \
		memcpy( (void *) (DST), (void *) (SRC), (size_t) (BYTES) )

void gluLookAt(float eyeX, float eyeY, float eyeZ, 
			   float lookAtX, float lookAtY, float lookAtZ, 
			   float upX, float upY, float upZ);

void gluPerspective(GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar);

static void transform_point(GLfloat out[4], const GLfloat m[16], const GLfloat in[4]);
static void matmul(GLfloat * product, const GLfloat * a, const GLfloat * b);
static GLboolean invert_matrix(const GLfloat * m, GLfloat * out);
GLint gluProject(GLfloat objx, GLfloat objy, GLfloat objz,
                 const GLfloat model[16], const GLfloat proj[16],
                 const GLint viewport[4],
                 GLfloat * winx, GLfloat * winy, GLfloat * winz);
GLint 
gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,
             const GLfloat model[16], const GLfloat proj[16],
             const GLint viewport[4],
             GLfloat * objx, GLfloat * objy, GLfloat * objz);
