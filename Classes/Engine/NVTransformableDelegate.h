//
//  NVTransformableDelegate.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/5/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NVTransformable;

@protocol NVTransformableDelegate <NSObject>
@optional
- (void) transformationWasResolved: (NVTransformable*) transformable;
@end
