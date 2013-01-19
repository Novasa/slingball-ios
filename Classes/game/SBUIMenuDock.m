//
//  SBUIMenuDock.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuDock.h"

#import "NVRenderStates.h"
#import "NVTextureCache.h"

#import "SBTextures.h"

@implementation SBUIMenuDock

- (id) init {
    if (self = [super init]) {
        self.layer = 4;
        self.state = (unsigned int)(void*)state_ui;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        GLfloat scaleWidthBy = (float)screenSize.width / 768.0f;
        GLfloat scaleHeightBy = (float)screenSize.height / 1024.0f;
        
        GLfloat width = menuIconTexWidth * scaleWidthBy;
        GLfloat height = menuIconTexHeight * scaleHeightBy;
        
        GLfloat offset = 22.0f;
        
        GLfloat x = offset;
        GLfloat y = screenSize.height - height - offset;
        
        NVRectFill(self.rect, x, y, width, height);
    }
    return self;
}

- (void) render {
    [[NVTextureCache sharedCache] setTextureFromImageNamed: @"texpak00.png"];
    
    glTexCoordPointer(2, GL_FLOAT, 0, menuIconTexCoords);
    
    [super render];
}


@end
