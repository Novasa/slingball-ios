//
//  SBScanlines.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/9/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBScanlines.h"

#import "SBRenderStates.h"

@implementation SBScanlines

- (id) init {
    if (self = [super init]) {
        self.layer = 3;
        self.isOpaque = NO;
        self.isFullscreen = YES;
        self.state = (unsigned int)(void*)state_scanlines;
        
        _spacing = 4.0f;
        _lineSize = 1.25f;
        
        _alpha = 0.1f;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        _lines = roundf(screenSize.height / _spacing);
        _vertices = malloc((_lines * 2) * sizeof(NVVertex));
        
        NSLog(@"%u", _lines);
        
        NSUInteger i = 1;
        
        for (NSUInteger j = 0; j < _lines * 2; j += 2) {          
            NSInteger const y = round(i++ * _spacing);

            kmVec3 left;
            kmVec3Fill(&left, 0, y, 0);
            
            kmVec3 right;
            kmVec3Fill(&right, screenSize.width, y, 0);
            
            NVVertex start;
            NVVertex end;
            
            start.vertex = left;
            end.vertex = right;
            
            _vertices[j] = start;
            _vertices[j + 1] = end;
        }
    }
    return self;
}

- (void) render {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
  
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0, screenSize.width, 0, screenSize.height, 0, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glVertexPointer(3, GL_FLOAT, sizeof(NVVertex), &_vertices[0].vertex);

    glLineWidth(_lineSize);
    glColor4f(0, 0, 0, _alpha);
    
    glDrawArrays(GL_LINES, 0, _lines * 2);
    
    glLineWidth(1.0f);
}

@end
