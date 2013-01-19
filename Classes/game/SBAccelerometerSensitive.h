//
//  SBAccelerometerSensitive.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"
#import "NVTransformable.h"

@interface SBAccelerometerSensitive : NVComponent <UIAccelerometerDelegate> {
 @private
    REQUIRES(NVTransformable, _transform);
    
    float _smoothingFactor;
    float _sensitivity;
    
    float _previousAccelerationX;
    float _previousAccelerationY;
}

@property(nonatomic, readwrite, assign) float smoothingFactor;
@property(nonatomic, readwrite, assign) float sensitivity;

@end
