//
//  NVLoadableAsync.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/17/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NVLoadableAsyncDelegate;

@protocol NVLoadableAsync <NSObject>
@required
- (void) loadWithDelegate: (id<NVLoadableAsyncDelegate>) delegate;
- (void) unloadWithDelegate: (id<NVLoadableAsyncDelegate>) delegate;
@end
