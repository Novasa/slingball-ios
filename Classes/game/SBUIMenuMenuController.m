//
//  SBUIMenuMenuController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuMenuController.h"

#import "NVGame.h"
#import "NVSchedulingService.h"

#import "SBSlingController.h"

#import "SBRotateAroundAxis.h"
#import "SBAccelerometerSensitive.h"
#import "SBInstructionsController.h"

@implementation SBUIMenuMenuController

- (void) interpolatorDidStep: (NVInterpolator*) interpolator {
    kmVec3 cameraTarget;
    kmVec3Fill(&cameraTarget, 0, 10, 0);
    
    kmVec3 cameraPosition;
    kmVec3Fill(&cameraPosition, 5, -15, 10);
    
    kmVec3 interpolatedPosition;
    kmVec3Lerp(&interpolatedPosition, &_cameraOriginalPosition, &cameraPosition, interpolator.weight);
    
    kmVec3Lerp(_camera.target, &_cameraOriginalTarget, &cameraTarget, interpolator.weight);
    
    _cameraTransform.position = interpolatedPosition;    
}

- (void) didClick {
    [super didClick];
    
    [self toggleSlideInOut];
    
    SBUIMenuController* menuPlay = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_play"];
    SBUIMenuController* menuAbout = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_about"];
    SBUIMenuController* menuBack = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_back"];

    [menuBack toggleSlideInOut];
    [menuAbout toggleSlideInOut];
    [menuPlay toggleSlideInOut];
    
    SBRotateAroundAxis* cameraRotate = [self.database getComponentOfType: [SBRotateAroundAxis class] fromGroup: @"camera"];
    
    cameraRotate.isEnabled = YES;

    NVInterpolator* interpolator = [[[NVGame sharedGame] scheduling] nextAvailableInterpolator];
    
    interpolator.duration = 1.0f;
    
    if ([interpolator beginWithDelegate: self]) {
        kmVec3Assign(&_cameraOriginalTarget, _camera.target);
        
        _cameraOriginalPosition = _cameraTransform.position;
    } else {
        Debug((@"no available interpolator :'("));
    }
    
    SBSlingController* playerOneSling = [self.database getComponentOfType: [SBSlingController class] fromGroup: @"player_one"];
    SBSlingController* playerTwoSling = [self.database getComponentOfType: [SBSlingController class] fromGroup: @"player_two"];
    
    playerOneSling.acceptsInput = NO;
    playerTwoSling.acceptsInput = NO;
    
    _overlay.isVisible = NO;
    
    SBAccelerometerSensitive* accelerometerSensitive = [self.database getComponentOfType: [SBAccelerometerSensitive class] 
                                                                               fromGroup: @"camera"];
    
    accelerometerSensitive.isEnabled = NO;
    
    SBInstructionsController* playerOneInstructions = [self.database getComponentOfType: [SBInstructionsController class] fromGroup: @"player_one_instructions"];
    SBInstructionsController* playerTwoInstructions = [self.database getComponentOfType: [SBInstructionsController class] fromGroup: @"player_two_instructions"];
    
    [playerOneInstructions fadeOut];
    [playerTwoInstructions fadeOut];
}

@end
