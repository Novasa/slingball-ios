/*
 *  NVTypes.h
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 12/21/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

typedef struct {
    kmVec3 origin;
    kmVec3 direction;
} NVRay;

typedef struct {
    kmVec3 origin;
    kmVec3 normal;
} NVPlane;

typedef struct {
    kmVec3 min;
    kmVec3 max;
} NVAABB;

typedef struct {
    float x;
    float y;
    float width;
    float height;
} NVRect;

typedef struct {
    kmVec3 center;
    float radius;
} NVSphere;

typedef struct {
	GLubyte	red;
	GLubyte	green;
	GLubyte	blue;
	GLubyte alpha;
} NVColor4b;

typedef struct {
	GLfloat red;
	GLfloat	green;
	GLfloat	blue;
	GLfloat alpha;
} NVColor4f;

typedef struct {
    kmVec3 vertex; // TODO: should be renamed "position"
} NVVertex;

typedef struct {
    kmVec3 vertex;
    NVColor4f color;
} NVColoredVertex;

typedef struct {
    kmVec3 vertex;
    kmVec3 normal;
} NVNormalVertex;

typedef struct {
    kmVec3 vertex;
    kmVec3 normal;
    kmVec3 texcoords;
} NVNormalVertexTexture;

typedef struct {
    kmVec3 vertex;
    kmVec3 normal;
    NVColor4f color;
} NVColoredNormalVertex;
