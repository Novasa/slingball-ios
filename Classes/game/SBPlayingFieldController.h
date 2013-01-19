//
//  SBPlayingFieldController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"
#import "NVTransformable.h"
#import "NVTransformableDelegate.h"

@interface SBPlayingFieldController : NVComponent <NVTransformableDelegate> {
 @private
    REQUIRES(NVTransformable, _transform);
    
    float _friction;
}

@property(nonatomic, readonly) float friction;

@property(nonatomic, readonly) float width;
@property(nonatomic, readonly) float height;

@property(nonatomic, readonly) float goalWidth;
@property(nonatomic, readonly) float goalHeight;

@end
