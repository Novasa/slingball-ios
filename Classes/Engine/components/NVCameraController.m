//
//  NVCameraController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/11/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVCameraController.h"

#import "SynthesizeSingleton.h"

@implementation NVCameraController

SYNTHESIZE_SINGLETON_FOR_CLASS(NVCameraController, Controller);

- (NVCamera*) camera {
    return _activeCamera;
}

- (void) setActiveCamera: (NVCamera*) camera {
    [self setActiveCamera: camera afterDelay: 0.0f];
}

- (void) setActiveCamera: (NVCamera*) camera afterDelay: (float) delay {
    _activeCamera = camera;
}

@end
