//
//  SBGoalControllerDelegate.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/12/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBGoalController;

@protocol SBGoalControllerDelegate <NSObject>
@required
- (BOOL) isWaitingToResetBall;
@optional
- (void) goalDidCatchBall: (SBGoalController*) goal;
@end
