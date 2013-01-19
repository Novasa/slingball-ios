//
//  SBSetupMenuScene.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSetupMenuScene.h"

#import "SBUIMenuController.h"
#import "NVScreenSpacedRectangle.h"

@implementation SBSetupMenuScene

- (void) start {
    [super start];
    
    SBUIMenuController* menuDock = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_dock"];
    SBUIMenuController* menuMenu = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_menu"];
    SBUIMenuController* menuBack = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_back"];
    SBUIMenuController* menuAboutContents = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_about_contents"];
    
    NVScreenSpacedRectangle* menuDockGraphic = [self.database getComponentOfAnyType: [NVScreenSpacedRectangle class] fromGroup: @"menu_dock"];
    NVScreenSpacedRectangle* menuMenuGraphic = [self.database getComponentOfAnyType: [NVScreenSpacedRectangle class] fromGroup: @"menu_menu"];
    NVScreenSpacedRectangle* menuBackGraphic = [self.database getComponentOfAnyType: [NVScreenSpacedRectangle class] fromGroup: @"menu_back"];
    NVScreenSpacedRectangle* menuAboutContentsGraphic = [self.database getComponentOfAnyType: [NVScreenSpacedRectangle class] fromGroup: @"menu_about_contents"];
    
    [menuDock slideOut];
    [menuMenu slideOut];
    [menuBack slideOut];
    [menuAboutContents slideOut];
    
    menuDockGraphic.isVisible = NO;
    menuMenuGraphic.isVisible = NO;
    menuBackGraphic.isVisible = NO;
    menuAboutContentsGraphic.isVisible = NO;
    
    [self unbindAndCommit];
}

@end
