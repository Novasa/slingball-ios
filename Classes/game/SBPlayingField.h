//
//  SBPlayingField.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVTransformable.h"
#import "NVRenderable.h"
#import "SBPlayingFieldController.h"

@interface SBPlayingField : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBPlayingFieldController, _controller);
}

@end
