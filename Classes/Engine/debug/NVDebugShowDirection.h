//
//  NVDebugShowDirection.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

@interface NVDebugShowDirection : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    kmVec3* _direction;
    
    BOOL _shouldAlwaysNormalize;
    BOOL _shouldDisplayOriginAndDirectionText;
}

@property(nonatomic, readonly) kmVec3* direction;
@property(nonatomic, readwrite, assign) BOOL shouldAlwaysNormalize;
@property(nonatomic, readwrite, assign) BOOL shouldDisplayOriginAndDirectionText;

@end
