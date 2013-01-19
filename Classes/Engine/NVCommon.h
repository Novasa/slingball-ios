/*
 *  NVCommon.h
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 12/21/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

#import "math/glu.h"

#import "NVTypes.h"

#define NVColor4fFFromRGBA(r,g,b,a) NVColor4fMake(r/255.0f, g/255.0f, b/255.0f, a/255.0f)
#define NVColor4FFromHex(hex) NVColor4fMake(((float)((hex & 0xFF0000) >> 16))/255.0f, ((float)((hex & 0xFF00) >> 8))/255.0f, ((float)(hex & 0xFF))/255.0f, 1.0f)

static inline float random_float() {
    return rand() / (RAND_MAX+1.0f);
}

static inline bool floats_are_almost_equal(float const a, float const b) {
    return (fabs(b - a) < kmEpsilon);
}

static inline void create_circle(NVVertex* vertices, float radius, int segments) {
    GLfloat x = 0;
    GLfloat y = 0;
    GLfloat z = 0;
    
    GLfloat angleStep = 2.0f * kmPI / segments;
    
    for (GLfixed i = 0; i < segments; i++) {
        GLfloat angle = i * angleStep;
        GLfloat bx = x + radius * cosf(angle);
        GLfloat by = y + radius * sinf(angle);
        
        NVVertex vertex;
        
        vertex.vertex.x = bx;
        vertex.vertex.y = by;
        vertex.vertex.z = z;
        
        vertices[i] = vertex;
    }
    
    NVVertex vertex;
    
    vertex.vertex.x = vertices[0].vertex.x;
    vertex.vertex.y = vertices[0].vertex.y;
    vertex.vertex.z = vertices[0].vertex.z;
    
    vertices[segments] = vertex;
}

static inline void create_filled_circle(NVVertex* vertices, float radius, int segments) {
    GLfloat x = 0;
    GLfloat y = 0;
    GLfloat z = 0;
    
    GLfloat angleStep = 2.0f * kmPI / segments;
    
    NVVertex center;
    
    center.vertex.x = x;
    center.vertex.y = y;
    center.vertex.z = z;
    
    vertices[0] = center;
    
    for (GLfixed i = 0; i < segments; i++) {
        GLfloat angle = i * angleStep;
        GLfloat bx = x + radius * cosf(angle);
        GLfloat by = y + radius * sinf(angle);
        
        NVVertex vertex;
        
        vertex.vertex.x = bx;
        vertex.vertex.y = by;
        vertex.vertex.z = z;
        
        vertices[i] = vertex;
    }
    
    NVVertex vertex;
    
    vertex.vertex.x = vertices[1].vertex.x;
    vertex.vertex.y = vertices[1].vertex.y;
    vertex.vertex.z = vertices[1].vertex.z;
    
    vertices[segments] = vertex;    
}

static inline kmVec3* screen_to_unitsphere(kmVec3* pOut, GLfixed mx, GLfixed my, GLfixed width, GLfixed height) {
    GLfloat x = mx / (width / 2.0f);
    GLfloat y = my / (height / 2.0f);
    
    x = x - 1.0f;
    y = 1.0f - y;
    
    GLfloat z2 = 1.0f - x * x - y * y;
    GLfloat z = z2 > 0.0f ? sqrtf(z2) : 0.0f;
    
    kmVec3Normalize(pOut, kmVec3Fill(pOut, x, y, z));
    
    return pOut;
}

static inline kmMat4* billboard(kmMat4* pOut, const GLfloat model[16]) {    
    kmVec3 right;
    kmVec3 up;
    kmVec3 forward;
    
    kmVec3Normalize(&up, kmVec3Fill(&up, model[1], model[5], model[9]));
    kmVec3Normalize(&right, kmVec3Fill(&right, model[0], model[4], model[8]));
    kmVec3Normalize(&forward, kmVec3Cross(&forward, &right, &up));
    
    kmMat4 rotation;
    kmMat4Identity(&rotation);
    
    rotation.mat[0] = right.x;
    rotation.mat[1] = right.y;
    rotation.mat[2] = right.z;
    
    rotation.mat[4] = up.x;
    rotation.mat[5] = up.y;
    rotation.mat[6] = up.z;
    
    rotation.mat[8] = forward.x;
    rotation.mat[9] = forward.y;
    rotation.mat[10] = forward.z;
    
    kmMat4Assign(pOut, &rotation);
    
    return pOut;
}

static inline void assign_random_orbital_axis(kmVec3* pOut) {
    float orbitalAxisX = rand() / (RAND_MAX+1.0f);
    float orbitalAxisY = rand() / (RAND_MAX+1.0f);
    float orbitalAxisZ = rand() / (RAND_MAX+1.0f);
    
    orbitalAxisX = (rand() % 2) > 0 ? -orbitalAxisX : orbitalAxisX;
    orbitalAxisY = (rand() % 2) > 0 ? -orbitalAxisY : orbitalAxisY;
    orbitalAxisZ = (rand() % 2) > 0 ? -orbitalAxisZ : orbitalAxisZ;
    
    kmVec3 orbitalAxis;
    kmVec3Fill(&orbitalAxis, orbitalAxisX, orbitalAxisY, orbitalAxisZ);
    kmVec3Normalize(&orbitalAxis, &orbitalAxis);
    
    kmVec3Assign(pOut, &orbitalAxis);
}

static inline void assign_random_position_outwards_from_origin(kmVec3* pOut) {
    float posx = rand() / (RAND_MAX+1.0f);
    float posy = rand() / (RAND_MAX+1.0f);
    float posz = rand() / (RAND_MAX+1.0f);
    
    posx = (rand() % 2) > 0 ? -posx : posx;
    posy = (rand() % 2) > 0 ? -posy : posy;
    posz = (rand() % 2) > 0 ? -posz : posz;
    
    kmVec3Fill(pOut, posx, posy, posz);
}

static inline void orient_to_spherical_surface(kmMat4* pOut, kmVec3* normal) {
    kmVec3 worldUp;
    kmVec3Fill(&worldUp, 0, 1, 0);
    
    kmScalar dx = normal->x;
    kmScalar dy = normal->y;
    kmScalar dz = normal->z;
    
    kmVec3 up;
    kmVec3 right;
    kmVec3 forward;
    
    kmVec3Normalize(&forward, kmVec3Fill(&forward, dx, dy, dz));
    kmVec3Normalize(&right, kmVec3Cross(&right, &forward, &worldUp));
    kmVec3Normalize(&up, kmVec3Cross(&up, &forward, &right));
    
    pOut->mat[4] = up.x;
    pOut->mat[5] = up.y;
    pOut->mat[6] = up.z;
    
    pOut->mat[0] = right.x;
    pOut->mat[1] = right.y;
    pOut->mat[2] = right.z;
    
    pOut->mat[8] = forward.x;
    pOut->mat[9] = forward.y;
    pOut->mat[10] = forward.z;
}

static inline kmVec3* closest_point_on_segment(kmVec3* pOut, kmVec3* a, kmVec3* b, kmVec3* p) {
    kmVec3 delta;
    kmVec3Subtract(&delta, b, a);
    
    float delta_dot_delta = kmVec3Dot(&delta, &delta);
    
    kmVec3 deltaP;
    kmVec3Subtract(&deltaP, p, a);
    
    float deltaP_dot_delta = kmVec3Dot(&deltaP, &delta);
    
    float t = deltaP_dot_delta / delta_dot_delta;
    
    if (t < 0.0f) {
        t = 0.0f;
    } else if (t > 1.0f) {
        t = 1.0f;
    }
    
    kmVec3 result;
    kmVec3 movement;
    
    kmVec3Scale(&movement, &delta, t);
    kmVec3Add(&result, a, &movement);
    
    kmVec3Assign(pOut, &result);
    
    return pOut;
}

static inline kmVec3* closest_point_on_segment_that_hits_sphere_surface(kmVec3* pOut, kmVec3* P, kmVec3* D, kmVec3* C, float R) {
    kmVec3 V;
    kmVec3Subtract(&V, P, C);
    
    float DV = kmVec3Dot(D, &V);
    float D2 = kmVec3Dot(D, D);
    float SQ = DV * DV - D2 * (kmVec3Dot(&V, &V) - R * R);
    
    if (SQ < 0) {
        return pOut;
    }
    
    SQ = sqrtf(SQ);
    
    float T1 = (-DV + SQ) / D2;
    float T2 = (-DV - SQ) / D2;
    
    float t = T1 < T2 ? T1 : T2;
    
    kmVec3Assign(pOut, P);
    
    kmVec3 movement;
    kmVec3Scale(&movement, D, t);
    
    kmVec3Add(pOut, pOut, &movement);
    
    return pOut;
}

static inline bool point_is_in_sphere(kmVec3* p, kmVec3* origin, float radius) {
    kmVec3 delta;
    kmVec3Subtract(&delta, p, origin);
    
    float delta_dot_delta = kmVec3Dot(&delta, &delta);
    float radius_squared = radius * radius;
    
    return !(delta_dot_delta > radius_squared);
}

static inline NVRay* create_ray_from_screen_location(NVRay* pOut, GLfloat x, GLfloat y, const GLfloat model[16], const GLfloat projection[16], const GLint view[4]) {
    GLfloat nx, ny, nz;
    GLfloat fx, fy, fz;
    
    GLfloat screenx = x;
    GLfloat screeny = view[3] - y;
    
    gluUnProject(screenx, screeny, 0, model, projection, view, &nx, &ny, &nz);
    gluUnProject(screenx, screeny, 1, model, projection, view, &fx, &fy, &fz);
    
    GLfloat dx = fx - nx;
    GLfloat dy = fy - ny;
    GLfloat dz = fz - nz;
    
    kmVec3 normalizedDirection;
    kmVec3Normalize(&normalizedDirection, kmVec3Fill(&normalizedDirection, dx, dy, dz));
    
    kmVec3Fill(&pOut->origin, nx, ny, nz);
    kmVec3Assign(&pOut->direction, &normalizedDirection);
    
    return pOut;
}

static inline kmVec3* ray_plane_intersection(kmVec3* pOut, NVRay* ray, NVPlane* plane) {
    kmVec3 delta;
    kmVec3Subtract(&delta, &plane->origin, &ray->origin);
    
    GLfloat distance = kmVec3Dot(&plane->normal, &delta) / kmVec3Dot(&plane->normal, &ray->direction);
    
    kmVec3 direction;
    kmVec3Scale(&direction, &ray->direction, distance);
    
    kmVec3Add(pOut, &ray->origin, &direction);
    
    return pOut;
}

static inline NVRay NVRayMake(float originx, float originy, float originz, float directionx, float directiony, float directionz) {
    NVRay ray;
    
    kmVec3 origin;
    kmVec3Fill(&origin, originx, originy, originz);
    
    kmVec3 direction;
    kmVec3Fill(&direction, directionx, directiony, directionz);
    
    ray.origin = origin;
    ray.direction = direction;
    
    return ray;
}

static inline NVPlane NVPlaneMake(float originx, float originy, float originz, float normalx, float normaly, float normalz) {
    NVPlane plane;
    
    kmVec3 origin;
    kmVec3Fill(&origin, originx, originy, originz);
    
    kmVec3 normal;
    kmVec3Fill(&normal, normalx, normaly, normalz);
    
    plane.origin = origin;
    plane.normal = normal;
    
    return plane;
}

static inline NVRect NVRectMake(float x, float y, float width, float height) {
    NVRect rect;
    
    rect.x = x;
    rect.y = y;
    rect.width = width;
    rect.height = height;    
    
    return rect;
}

static inline NVRect* NVRectFill(NVRect* pOut, float x, float y, float width, float height) {
    pOut->x = x;
    pOut->y = y;
    pOut->width = width;
    pOut->height = height;
    
    return pOut;
}

static inline NVRect* NVRectAssign(NVRect* pOut, NVRect* rect) {
    pOut->x = rect->x;
    pOut->y = rect->y;
    pOut->width = rect->width;
    pOut->height = rect->height;    
    
    return pOut;
}

static inline NVColor4f NVColor4fMake(float r, float g, float b, float a) {
    NVColor4f color;
    
    color.red = r;
    color.green = g;
    color.blue = b;
    color.alpha = a;
    
    return color;
}

static inline NVColor4f* NVColor4fFill(NVColor4f* pOut, float r, float g, float b, float a) {
    pOut->red = r;
    pOut->green = g;
    pOut->blue = b;
    pOut->alpha = a;
    
    return pOut;
}

static inline NVColor4f* NVColor4fAssign(NVColor4f* pOut, NVColor4f* color) {
    pOut->red = color->red;
    pOut->green = color->green;
    pOut->blue = color->blue;
    pOut->alpha = color->alpha;    
    
    return pOut;
}
