//
//  SBBallRibbon.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBBallRibbon.h"

#import "NVCameraController.h"

#import "SBRenderStates.h"

@implementation SBBallRibbon

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = NO;
        self.state = (unsigned int)(void*)state_sling_ribbon;
        
        _vertices = malloc((kMaxBallRibbonSegments * 2) * sizeof(NVColoredVertex));
        
        _startColor = malloc(sizeof(NVColor4f));
        _endColor = malloc(sizeof(NVColor4f));
        
        NVColor4fFill(_startColor, 1, 1, 1, 0.25f);
        NVColor4fFill(_endColor, 1, 1, 1, 0);
    }
    return self;
}

- (void) start {
    [super start];
    
    _initialRadius = (_collider.radius / 2) * 0.65f;
}

- (void) render {
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    kmMat4 world;
    kmMat4Identity(&world);
    
    kmMat4 modelview;
    kmMat4Multiply(&modelview, &view, &world);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(modelview.mat);
    
    int j = 0;
    for (int i = 0; i < kMaxBallRibbonSegments * 2; i += 2) {
        SBBallRibbonSegment* segment = [_controller segmentAtIndex: j];
        
        NVColoredVertex a;
        NVColoredVertex b;
        
        float t = (float)j / kMaxBallRibbonSegments;
        float r = _initialRadius * (1 - t);
        
        kmVec3 pa;
        kmVec3Add(&pa, &segment->position, kmVec3Scale(&pa, &segment->axis, r));
        
        kmVec3 pb;
        kmVec3Add(&pb, &segment->position, kmVec3Scale(&pb, &segment->axis, -r));
        
        a.vertex = pa;
        b.vertex = pb;
        
        NVColor4f color = 
        NVColor4fMake(lerp(_startColor->red, _endColor->red, t), 
                      lerp(_startColor->green, _endColor->green, t), 
                      lerp(_startColor->blue, _endColor->blue, t), 
                      lerp(_startColor->alpha, _endColor->alpha, t));
        
        a.color = color;
        b.color = color;
        
        _vertices[i] = b;
        _vertices[i + 1] = a;
        
        j++;
    }
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVColoredVertex), &_vertices[0].vertex);
    glColorPointer(4, GL_FLOAT, sizeof(NVColoredVertex), &_vertices[0].color);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, kMaxBallRibbonSegments * 2);
}

- (void) dealloc {
    free(_startColor);
    free(_endColor);
    
    free(_vertices);
    
    [super dealloc];
}

@end
