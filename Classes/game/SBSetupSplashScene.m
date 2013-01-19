//
//  SBSetupSplashScene.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSetupSplashScene.h"

#import "NVTransformable.h"
#import "NVCameraController.h"
#import "NVLookAtCamera.h"
#import "NVScreenSpacedRectangle.h"
#import "NVFullscreenFadeInOutController.h"

#import "SBGroups.h"
#import "SBAccelerometerSensitive.h"

@implementation SBSetupSplashScene

- (void) start {
    [super start];
    
    NVLookAtCamera* camera = [self.database getComponentOfType: [NVLookAtCamera class] fromGroup: kGroupCamera];
    NVTransformable* cameraTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: camera.group];
    NVScreenSpacedRectangle* screenSizedRectangle = [self.database getComponentOfType: [NVScreenSpacedRectangle class] fromGroup: camera.group];
    SBAccelerometerSensitive* accelerometerSensitive = [self.database getComponentOfType: [SBAccelerometerSensitive class] fromGroup: camera.group];
    
    accelerometerSensitive.sensitivity = 50;
    
    NVColor4f cameraClearColor = NVColor4fMake(35.0f / 255.0f, 
                                               40.0f / 255.0f, 
                                               47.0f / 255.0f, 
                                               1.0f);
    
    camera.clearColor = cameraClearColor;
    
    NVColor4fAssign(screenSizedRectangle.color, &cameraClearColor);
    
    kmVec3 cameraPosition;
    kmVec3Fill(&cameraPosition, 0, 0, 5);
    
    cameraTransform.position = cameraPosition;   
    
    [[NVCameraController sharedController] setActiveCamera: camera];
    
    NVFullscreenFadeInOutController* fader = [self.database getComponentOfType: [NVFullscreenFadeInOutController class] 
                                                                     fromGroup: kGroupCamera];
 
    [fader fadeOutWithDuration: 1.0f];
    
    [self unbindAndCommit];
}

@end
