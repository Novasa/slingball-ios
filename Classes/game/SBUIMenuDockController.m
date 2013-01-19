//
//  SBUIMenuDockController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuDockController.h"

#import "SBSlingController.h"
#import "SBRenderStates.h"

@implementation SBUIMenuDockController

- (void) start {
    [super start];
    
    _overlay.layer = 1;
    _overlay.state = (unsigned int)(void*)state_dimmed_overlay;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NVRectFill(_overlay.rect, 0, 0, screenSize.width, screenSize.height);
    NVColor4fFill(_overlay.color, 0, 0, 0, 0.5f);
    
    _overlay.isVisible = NO;
}

- (void) toggleSlideInOut {
    [super toggleSlideInOut];
    
    _overlay.isVisible = !self.isSlidIn;
}

- (void) didClick {
    [super didClick];
    
    [self toggleSlideInOut];

    SBUIMenuController* menuMenu = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_menu"];
    SBUIMenuController* menuBack = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_back"];
    SBUIMenuController* menuLogo = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_logo"];
    
    [menuLogo toggleSlideInOut];
    [menuMenu toggleSlideInOut];
    [menuBack toggleSlideInOut];
    
    SBSlingController* playerOneSling = [self.database getComponentOfType: [SBSlingController class] fromGroup: @"player_one"];
    SBSlingController* playerTwoSling = [self.database getComponentOfType: [SBSlingController class] fromGroup: @"player_two"];
    
    playerOneSling.acceptsInput = NO;
    playerTwoSling.acceptsInput = NO;
}

@end
