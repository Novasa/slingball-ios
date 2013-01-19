//
//  SBUIMenuDockController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVScreenSpacedRectangle.h"

#import "SBUIMenuController.h"

@interface SBUIMenuDockController : SBUIMenuController {
 @private
    REQUIRES_FROM_GROUP(NVScreenSpacedRectangle, _overlay, dimmed_overlay);
}

@end
