//
//  SBUIMenuPlayController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBUIMenuPlayController.h"

#import "SBSlingController.h"
#import "SBReferee.h"

#import "NVGame.h"
#import "NVSchedulingService.h"

#import "SBRotateAroundAxis.h"
#import "SBInstructionsController.h"
#import "SBAccelerometerSensitive.h"

@implementation SBUIMenuPlayController

- (void) interpolatorDidStep: (NVInterpolator*) interpolator {
    kmVec3 interpolatedPosition;
    kmVec3Lerp(&interpolatedPosition, &_cameraOriginalPosition, &_cameraDesiredPosition, interpolator.weight);
    kmVec3Lerp(_camera.target, &_cameraOriginalTarget, &_cameraDesiredTarget, interpolator.weight);
    
    _cameraTransform.position = interpolatedPosition;
    
    kmQuaternion interpolatedRotation;
    kmQuaternionSlerp(&interpolatedRotation, &_cameraOriginalRotation, &_cameraDesiredRotation, interpolator.weight);
    
    _cameraTransform.rotation = interpolatedRotation;
}

- (void) interpolatorDidFinish: (NVInterpolator*) interpolator {
    SBAccelerometerSensitive* accelerometerSensitive = [self.database getComponentOfType: [SBAccelerometerSensitive class] 
                                                                               fromGroup: @"camera"];
    
    accelerometerSensitive.isEnabled = YES;
}

- (void) didClick {
    [super didClick];
    
    SBReferee* referee = [self.database getComponentOfType: [SBReferee class] fromGroup: @"referee"];
    
    [referee resetGame];
    
    [self toggleSlideInOut];
    
    SBUIMenuController* menuDock = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_dock"];
    SBUIMenuController* menuAbout = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_about"];
    SBUIMenuController* menuLogo = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_logo"];
    
    [menuLogo toggleSlideInOut];
    [menuAbout toggleSlideInOut];
    [menuDock toggleSlideInOut];
   
    SBRotateAroundAxis* cameraRotate = [self.database getComponentOfType: [SBRotateAroundAxis class] fromGroup: @"camera"];
    
    cameraRotate.isEnabled = NO;
    
    _cameraOriginalPosition = _cameraTransform.position;
    _cameraOriginalRotation = _cameraTransform.rotation;
    
    kmQuaternionIdentity(&_cameraDesiredRotation);
    kmVec3Assign(&_cameraOriginalTarget, _camera.target);
    kmVec3Fill(&_cameraDesiredPosition, 0, 0, 16);
    kmVec3Fill(&_cameraDesiredTarget, 0, 0, 0);

    NVInterpolator* interpolator = [[[NVGame sharedGame] scheduling] nextAvailableInterpolator];
    
    if (interpolator != nil) {
        interpolator.duration = 1.0f;
        
        if ([interpolator beginWithDelegate: self]) {

        }
    }
    
    SBInstructionsController* playerOneInstructions = [self.database getComponentOfType: [SBInstructionsController class] fromGroup: @"player_one_instructions"];
    SBInstructionsController* playerTwoInstructions = [self.database getComponentOfType: [SBInstructionsController class] fromGroup: @"player_two_instructions"];
    
    [playerOneInstructions fadeIn];
    [playerTwoInstructions fadeIn];
}

@end
