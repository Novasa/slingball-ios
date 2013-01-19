//
//  SBSlingIdlePulse.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"
#import "SBSlingBody.h"
#import "SBSlingController.h"

@class SBSlingIdlePulseController;

@interface SBSlingIdlePulse : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBSlingBody, _body);
    REQUIRES(SBSlingController, _controller);
    REQUIRES(SBSlingIdlePulseController, _idleController);
    
    NVVertex* _vertices;
}

@end
