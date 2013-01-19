//
//  SBLoadingIndicator.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "SBLoadingIndicatorController.h"

@interface SBLoadingIndicator : NVRenderable {
 @private
    REQUIRES(SBLoadingIndicatorController, _controller);
}

@end
