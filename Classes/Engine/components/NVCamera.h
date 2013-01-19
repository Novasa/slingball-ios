//
//  NVCamera.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/19/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"

@interface NVCamera : NVComponent {
 @protected
    kmMat4* _view;
    kmMat4* _projection;
    
    NVColor4f* _clearColor;
    
 @private    
    float _near, _far;
    float _fov;
    float _ar;
    
    float _clearDepth;
}

@property(nonatomic, readwrite, assign) float aspectRatio;
@property(nonatomic, readwrite, assign) float fieldOfView;
@property(nonatomic, readwrite, assign) float near;
@property(nonatomic, readwrite, assign) float far;

@property(nonatomic, readwrite, assign) float clearDepth;

- (void) construct;

@property(nonatomic, readonly) kmMat4 view;
@property(nonatomic, readonly) kmMat4 projection;

@property(nonatomic, readwrite, assign) NVColor4f clearColor;

- (kmVec3) screenLocationFromWorldPoint: (kmVec3) point;
- (kmVec3) worldPointFromScreenLocation: (kmVec3) location;

- (NVRay) rayFromScreenLocation: (CGPoint) location;

@end
