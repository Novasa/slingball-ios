//
//  SBAccelerometerSensitive.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBAccelerometerSensitive.h"

@implementation SBAccelerometerSensitive

@synthesize smoothingFactor = _smoothingFactor;
@synthesize sensitivity = _sensitivity;

- (id) init {
    if (self = [super init]) {
        _smoothingFactor = 0.333f;
        _sensitivity = 30;
        
        _previousAccelerationX = 0;
        _previousAccelerationY = 0;
    }
    return self;
}

- (void) start {
    [super start];
    
    UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
    
    accelerometer.delegate = self;
    accelerometer.updateInterval = FIXED_TIME_STEP;
}

- (void) end {
    [super end];
    
    if ([UIAccelerometer sharedAccelerometer].delegate == self) {
        [UIAccelerometer sharedAccelerometer].delegate = nil;
    }
}

- (void) accelerometer: (UIAccelerometer*) accelerometer didAccelerate: (UIAcceleration*) acceleration {
    if (!self.isEnabled) {
        return;
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (fabs(acceleration.x - _previousAccelerationX) > kmEpsilon &&
        fabs(acceleration.y - _previousAccelerationY) > kmEpsilon) {
        float const ax = orientation == UIDeviceOrientationPortraitUpsideDown ? -acceleration.x : acceleration.x;
        float const ay = orientation == UIDeviceOrientationPortraitUpsideDown ? -acceleration.y : acceleration.y;
        
        float x = lerp(_previousAccelerationX, ax * _sensitivity, _smoothingFactor);
        float y = lerp(_previousAccelerationY, ay * _sensitivity, _smoothingFactor);
        
        _previousAccelerationX = x;
        _previousAccelerationY = y;
        
        kmQuaternion newRotation;
        kmQuaternionRotationYawPitchRoll(&newRotation, -x, y, 0);  
        kmQuaternionNormalize(&newRotation, &newRotation);
        
        _transform.rotation = newRotation;
    }
}

@end
