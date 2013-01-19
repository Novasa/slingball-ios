//
//  NVCameraController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/11/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVCamera.h"

@interface NVCameraController : NSObject {
 @private
    NVCamera* _activeCamera;
}

+ (NVCameraController*) sharedController;

- (NVCamera*) camera;

- (void) setActiveCamera: (NVCamera*) camera;
- (void) setActiveCamera: (NVCamera*) camera afterDelay: (float) delay;

@end
