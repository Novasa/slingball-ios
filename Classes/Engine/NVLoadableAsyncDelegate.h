//
//  NVLoadableAsyncDelegate.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/17/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NVLoadableAsync;

@protocol NVLoadableAsyncDelegate <NSObject>
@optional
- (void) loadableDidLoad: (id<NVLoadableAsync>) loadable;
- (void) loadableDidUnload: (id<NVLoadableAsync>) loadable;
@end
