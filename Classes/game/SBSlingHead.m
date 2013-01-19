//
//  SBSlingHead.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/11/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingHead.h"

#import "SBRenderStates.h"

#import "NVCameraController.h"

#import "kugle.h"

@implementation SBSlingHead

@synthesize color = _color;

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_sling_head;
        
        _color = malloc(sizeof(NVColor4f));
        
        NVColor4fMake(1, 1, 1, 1);
    }
    return self;
}

- (void) render {
    NVSpringParticle* head = [_body head];
    
    if (head == NULL) {
        return;
    }
    
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    kmMat4 world = _transform.world;
 
    static GLfloat const lightPosition[] = { 
        0.0f, 0.0f, 1.0f, 0.0f
    };
    
    GLfloat const lightSlingHeadDiffuse[] = { 
        _color->red, _color->green, _color->blue, _color->alpha
    };
    
    glLightfv(GL_LIGHT0, GL_DIFFUSE, lightSlingHeadDiffuse);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glMultMatrixf(view.mat);
    glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);    
    glMultMatrixf(world.mat);
        
    kmVec3 right;
    kmVec3 up;
    
    kmVec3 forward;
    kmVec3Normalize(&forward, kmVec3Subtract(&forward, &[_body particleAtIndex: _body.particleCount - 2]->position, &head->position));
    
    kmVec3Normalize(&up, kmVec3Fill(&up, 0, 0, 1));
    kmVec3Normalize(&right, kmVec3Cross(&right, &up, &forward));
    
    kmMat4 rotation;
    kmMat4Identity(&rotation);
    
    rotation.mat[0] = right.x;
    rotation.mat[1] = right.y;
    rotation.mat[2] = right.z;

    rotation.mat[4] = forward.x;
    rotation.mat[5] = forward.y;
    rotation.mat[6] = forward.z;
    
    rotation.mat[8] = -up.x;
    rotation.mat[9] = -up.y;
    rotation.mat[10] = -up.z;
    
    GLfloat scale = _body.scaleHead;
    /*
    float speed = kmVec3Length(&[_body head]->velocity);
    float theta = (speed / scale) * 100;
    
    kmVec3 direction;
    kmVec3Normalize(&direction, &[_body head]->velocity);
    
    kmVec3 rotationAxis;
    kmVec3Cross(&rotationAxis, &direction, &up);
    
    kmQuaternion newRotation;
    kmQuaternionRotationAxis(&newRotation, &rotationAxis, theta);
    
    kmMat3 extractedRotation;
    kmMat4ExtractRotation(&extractedRotation, &rotation);
    
    kmQuaternion currentRotation;
    kmQuaternionRotationMatrix(&currentRotation, &extractedRotation);
    
    kmQuaternionAdd(&newRotation, &currentRotation, &newRotation);
    kmQuaternionNormalize(&newRotation, &newRotation);    
    
    kmMat4RotationQuaternion(&rotation, &currentRotation);*/
    
    glTranslatef(head->position.x, head->position.y, head->position.z);
    glMultMatrixf(rotation.mat);
    glScalef(scale, scale, scale);
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVNormalVertex), &SphereVertexData[0].vertex);
    glNormalPointer(GL_FLOAT, sizeof(NVNormalVertex), &SphereVertexData[0].normal);
    
    GLfloat shade = 0.75f;
    
    glColor4f(shade, shade, shade, 1.0f);
    
    glDrawArrays(GL_TRIANGLES, 0, kSphereNumberOfVertices);
}

- (void) dealloc {
    free(_color);
    
    [super dealloc];
}

@end
