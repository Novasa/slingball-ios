//
//  SBLoadingIndicator.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/16/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBLoadingIndicator.h"

#import "SBRenderStates.h"

@implementation SBLoadingIndicator

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.isFullscreen = YES;
        self.state = (unsigned int)(void*)state_loading_indicator;
    }
    return self;
}

- (void) render {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0, screenSize.width, 0, screenSize.height, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    GLfloat size = 6.0f;
    GLfloat s = size / 2;
    
    GLfloat largeScale = 1.333f;
    
    GLfloat spacing = 8;
    
    GLfloat combinedSpacingWidth = ([_controller indexCount] - 1) * spacing;
    GLfloat combinedTotalWidth = ([_controller indexCount] * size) + combinedSpacingWidth;
    
    GLfloat vertices[] = {
        -s, s,
        -s, -s,
        s, s,
        s, -s
    };

    glPushMatrix();
    {
        glTranslatef(screenSize.width / 2, screenSize.height / 2, 0);
        glTranslatef(-(combinedTotalWidth / 2) + (size / 2), 0, 0);
        
        glVertexPointer(2, GL_FLOAT, 0, vertices);
        
        glColor4f(1, 1, 1, 1);
        
        for (int i = 0; i < [_controller indexCount]; i++) {
            if (i == [_controller indexForCurrentFrame]) {
                glPushMatrix();
                
                glScalef(largeScale, largeScale, largeScale);
            }
            
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

            if (i == [_controller indexForCurrentFrame]) {
                glPopMatrix();
            }
            
            glTranslatef(size + spacing, 0, 0);
        }
    }
    glPopMatrix();
}

@end
