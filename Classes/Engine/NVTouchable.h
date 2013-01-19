//
//  NVTouchable.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NVTouchable <NSObject>
@optional
- (void) touchesBegan: (NSSet*) touches;
- (void) touchesMoved: (NSSet*) touches;
- (void) touchesEnded: (NSSet*) touches;
@end
