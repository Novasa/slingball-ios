//
//  SBBallRibbon.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

#import "SBBallCollider.h"
#import "SBBallRibbonController.h"

@interface SBBallRibbon : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBBallRibbonController, _controller);
    REQUIRES(SBBallCollider, _collider);
    
    float _initialRadius;
    
    NVColoredVertex* _vertices;
    
    NVColor4f* _startColor;
    NVColor4f* _endColor;
}

@end
