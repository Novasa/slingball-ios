//
//  SBSplashController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"
#import "NVTouchable.h"

@interface SBSplashController : NVSchedulable <NVTouchable> {
 @private
    BOOL _isInitiatingLoad;
    
    float _skipAfterDuration;    
    
    float _timeStarted;
    float _timeSinceStarted;
}

@end
