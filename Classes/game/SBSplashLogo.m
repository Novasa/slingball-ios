//
//  SBSplashLogo.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/19/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSplashLogo.h"

#import "NVCameraController.h"
#import "NVTextureCache.h"

#import "SBRenderStates.h"
#import "SBTextures.h"

@implementation SBSplashLogo

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.state = (unsigned int)(void*)state_splash_logo;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;

        GLfloat scaleWidthBy = (float)screenSize.width / 768.0f;
        GLfloat scaleHeightBy = (float)screenSize.height / 1024.0f;
        
        GLfloat width = novasaLogoTexWidth * scaleWidthBy;
        GLfloat height = novasaLogoTexHeight * scaleHeightBy;
        
        GLfloat cx = screenSize.width / 2;
        GLfloat cy = screenSize.height / 2;
        
        NVRectFill(self.rect, cx - (width / 2), cy - (height / 2), width, height);
        
        [[NVTextureCache sharedCache] setTextureFromImageNamed: @"texpak00.png"];
    }
    return self;
}

- (void) render {
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    NVColor4f clearColor = cam.clearColor;
    NVColor4fAssign(self.color, &clearColor);
    
    [[NVTextureCache sharedCache] setTextureFromImageNamed: @"texpak00.png"];

    glTexCoordPointer(2, GL_FLOAT, 0, novasaLogoTexCoords);
    
    [super render];
}

@end
