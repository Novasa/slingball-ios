//
//  SBUIMenuMenu.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuMenu.h"

#import "NVRenderStates.h"
#import "NVTextureCache.h"

#import "SBTextures.h"

@implementation SBUIMenuMenu

- (id) init {
    if (self = [super init]) {
        self.layer = 4;
        self.state = (unsigned int)(void*)state_ui;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        GLfloat scaleWidthBy = (float)screenSize.width / 768.0f;
        GLfloat scaleHeightBy = (float)screenSize.height / 1024.0f;
        
        GLfloat width = menuMenuTexWidth * scaleWidthBy;
        GLfloat height = menuMenuTexHeight * scaleHeightBy;
        
        GLfloat x = 63.0f;
        GLfloat y = screenSize.height - height - 51 * 3;
        
        NVRectFill(self.rect, x, y, width, height);
    }
    return self;
}

- (void) render {
    [[NVTextureCache sharedCache] setTextureFromImageNamed: @"texpak00.png"];
    
    glTexCoordPointer(2, GL_FLOAT, 0, menuMenuTexCoords);
    
    [super render];
}

@end
