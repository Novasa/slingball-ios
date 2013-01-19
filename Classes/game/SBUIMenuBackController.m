//
//  SBUIMenuBackController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuBackController.h"

#import "SBSlingController.h"

@implementation SBUIMenuBackController

- (void) didClick {
    [super didClick];
    
    [self toggleSlideInOut];
    
    SBUIMenuController* menuMenu = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_menu"];
    SBUIMenuController* menuDock = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_dock"];
    SBUIMenuController* menuLogo = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_logo"];
    
    [menuLogo toggleSlideInOut];
    [menuMenu toggleSlideInOut];
    [menuDock toggleSlideInOut];
    
    SBSlingController* playerOneSling = [self.database getComponentOfType: [SBSlingController class] fromGroup: @"player_one"];
    SBSlingController* playerTwoSling = [self.database getComponentOfType: [SBSlingController class] fromGroup: @"player_two"];
    
    playerOneSling.acceptsInput = YES;
    playerTwoSling.acceptsInput = YES;
}

@end
