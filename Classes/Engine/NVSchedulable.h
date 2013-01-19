//
//  NVSchedulable.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/17/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"

@interface NVSchedulable : NVComponent {

}

// t = current time (t / FIXED_TIME_STEP == total steps)
// dt = time step
- (void) step: (float) t delta: (float) dt;
// elapsed = time passed since start
// alpha = time remainder previous steps
- (void) update: (float) elapsed interpolation: (float) alpha;

@end
