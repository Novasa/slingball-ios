//
//  SBUIMenuAboutContentsController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/26/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuAboutContentsController.h"

@implementation SBUIMenuAboutContentsController

- (void) didClick {
    [super didClick];
    
    [self toggleSlideInOut];
    
    SBUIMenuController* menuPlay = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_play"];
    SBUIMenuController* menuAbout = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_about"];
    
    [menuPlay toggleSlideInOut];
    [menuAbout toggleSlideInOut];
}

@end
