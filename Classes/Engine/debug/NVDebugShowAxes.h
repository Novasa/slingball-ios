//
//  NVDebugShowAxes.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

@interface NVDebugShowAxes : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    BOOL _shouldDisplayAxesNames;
}

@property(nonatomic, readwrite, assign) BOOL shouldDisplayAxesNames;

@end
