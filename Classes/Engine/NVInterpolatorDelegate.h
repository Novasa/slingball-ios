//
//  NVInterpolatorDelegate.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NVInterpolator;

@protocol NVInterpolatorDelegate <NSObject>
@optional
- (void) interpolatorDidStep: (NVInterpolator*) interpolator;
- (void) interpolatorDidFinish: (NVInterpolator*) interpolator;
@end
