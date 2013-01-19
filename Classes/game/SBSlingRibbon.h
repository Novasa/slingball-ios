//
//  SBSlingRibbon.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/12/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"
#import "SBSlingBody.h"
#import "SBSlingRibbonController.h"

@interface SBSlingRibbon : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBSlingRibbonController, _controller);
    REQUIRES(SBSlingBody, _body);
        
    float _initialRadius;
    
    NVColoredVertex* _vertices;
    
    NVColor4f* _startColor;
    NVColor4f* _endColor;
}

@property(nonatomic, readonly) NVColor4f* startColor;
@property(nonatomic, readonly) NVColor4f* endColor;

@end
