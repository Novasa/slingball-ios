//
//  SBUIMenuAboutController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/26/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuAboutController.h"

@implementation SBUIMenuAboutController

- (void) didClick {
    [super didClick];
    
    [self toggleSlideInOut];
    
    SBUIMenuController* menuPlay = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_play"];
    SBUIMenuController* menuAboutContents = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_about_contents"];
    
    [menuPlay toggleSlideInOut];
    [menuAboutContents toggleSlideInOut];
}

@end
