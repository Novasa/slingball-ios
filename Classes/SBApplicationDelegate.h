//
//  SBApplicationDelegate.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright Novasa Interactive 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBEAGLView;

@interface SBApplicationDelegate : NSObject <UIApplicationDelegate> {
 @private
    UIWindow* _window;
    SBEAGLView* _glView;
}

@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet SBEAGLView *glView;

@end

