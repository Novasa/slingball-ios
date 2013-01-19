//
//  SBSetupPlayingScene.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSetupPlayingScene.h"

#import "NVGame.h"
#import "NVLookAtCamera.h"
#import "NVTransformable.h"

#import "SBGroups.h"
#import "SBAccelerometerSensitive.h"
#import "SBGoalBody.h"
#import "SBGoalController.h"
#import "SBSlingController.h"
#import "SBSlingBody.h"
#import "SBSlingHead.h"
#import "SBSlingRibbon.h"
#import "SBRotateAroundAxis.h"
#import "SBPlayingFieldSweepController.h"
#import "SBSlingHeadExplosionParticlesController.h"
#import "NVFullscreenFadeInOutController.h"

@implementation SBSetupPlayingScene

- (void) start {
    [super start];
        
    NVLookAtCamera* camera = [self.database getComponentOfType: [NVLookAtCamera class] fromGroup: kGroupCamera];
    NVTransformable* cameraTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: camera.group];
    SBAccelerometerSensitive* accelerometerSensitive = [self.database getComponentOfType: [SBAccelerometerSensitive class] fromGroup: camera.group];
    
    accelerometerSensitive.isEnabled = NO;
    accelerometerSensitive.sensitivity = 20;
    
    kmVec3 cameraPosition;
    
    kmVec3Fill(&cameraPosition, 5, -15, 10);
    kmVec3Fill(camera.target, 0, 10, 0);

    cameraTransform.position = cameraPosition;
    
    //[[NVGame sharedGame] unloadSceneNamed: @"loading"];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float aspectRatio = screenSize.height / screenSize.width;
    
    NVTransformable* playingFieldTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: kGroupPlayingField];
    
    kmVec3 playingFieldScale;
    kmVec3Fill(&playingFieldScale, 11.0f / aspectRatio, 11.0f, 1);
    
    playingFieldTransform.scale = playingFieldScale;

    NVTransformable* gridTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: @"feathered_grid"];

    kmVec3 gridScale;
    kmVec3Fill(&gridScale, (17.0f / aspectRatio) / 2, 17.0f / 2.0f, 1);
    kmVec3 gridPosition;
    kmVec3Fill(&gridPosition, 0, 0, -0.1f);
    
    gridTransform.scale = gridScale;
    gridTransform.position = gridPosition;
    
    NVTransformable* glowTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: @"glowing_box_boundary"];
    
    kmVec3 glowScale;
    kmVec3Fill(&glowScale, playingFieldScale.x / 2, playingFieldScale.y / 2, 1.5f);

    glowTransform.scale = glowScale;
    
    NVTransformable* ballTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: kGroupBall];
    
    kmVec3 ballScale;
    kmVec3Fill(&ballScale, 0.4f, 0.4f, 0.4f);
    
    ballTransform.scale = ballScale;
    
    SBGoalBody* goalPlayerOne = [self.database getComponentOfType: [SBGoalBody class] fromGroup: @"player_one_goal"];
    SBGoalBody* goalPlayerTwo = [self.database getComponentOfType: [SBGoalBody class] fromGroup: @"player_two_goal"];
    
    SBGoalController* goalPlayerOneController = [self.database getComponentOfType: [SBGoalController class] fromGroup: goalPlayerOne.group];
    SBGoalController* goalPlayerTwoController = [self.database getComponentOfType: [SBGoalController class] fromGroup: goalPlayerTwo.group];
    
    float goalEnergyLoss = 0.78f;
    
    goalPlayerOne.energyLoss = goalEnergyLoss;
    goalPlayerTwo.energyLoss = goalEnergyLoss;
    
    [goalPlayerOne createGoalForPlayerIndex: 1];
    [goalPlayerTwo createGoalForPlayerIndex: 2];
    
    [goalPlayerOneController calculateBounds];
    [goalPlayerTwoController calculateBounds];
    
    goalPlayerOneController.tag = kGroupPlayerOne;
    goalPlayerTwoController.tag = kGroupPlayerTwo;
    
    SBSlingBody* slingPlayerOne = [self.database getComponentOfType: [SBSlingBody class] fromGroup: kGroupPlayerOne];
    SBSlingBody* slingPlayerTwo = [self.database getComponentOfType: [SBSlingBody class] fromGroup: kGroupPlayerTwo];
    
    SBSlingHead* slingHeadPlayerOne = [self.database getComponentOfType: [SBSlingHead class] fromGroup: slingPlayerOne.group];
    SBSlingHead* slingHeadPlayerTwo = [self.database getComponentOfType: [SBSlingHead class] fromGroup: slingPlayerTwo.group];
    /*
    SBSlingRibbon* slingRibbonPlayerOne = [self.database getComponentOfType: [SBSlingRibbon class] fromGroup: slingPlayerOne.group];
    SBSlingRibbon* slingRibbonPlayerTwo = [self.database getComponentOfType: [SBSlingRibbon class] fromGroup: slingPlayerTwo.group];
    */
    SBSlingController* slingControllerPlayerOne = [self.database getComponentOfType: [SBSlingController class] fromGroup: slingPlayerOne.group];
    SBSlingController* slingControllerPlayerTwo = [self.database getComponentOfType: [SBSlingController class] fromGroup: slingPlayerTwo.group];
    
    slingControllerPlayerOne.acceptsInput = NO;
    slingControllerPlayerTwo.acceptsInput = NO;
    
    NVColor4f colorPlayerOne = NVColor4fMake(0.9f, 0.35f, 0.35f, 1);
    NVColor4f colorPlayerTwo = NVColor4fMake(0.35f, 0.35f, 0.9f, 1);
    
    NVColor4fAssign(slingHeadPlayerOne.color, &colorPlayerOne);
    NVColor4fAssign(slingHeadPlayerTwo.color, &colorPlayerTwo);
    /*
    NVColor4fAssign(slingRibbonPlayerOne.startColor, &colorPlayerOne);
    NVColor4fAssign(slingRibbonPlayerTwo.startColor, &colorPlayerTwo);
    */
    float slingEnergyLoss = 0.78f;
    
    slingPlayerOne.energyLoss = slingEnergyLoss;
    slingPlayerTwo.energyLoss = slingEnergyLoss;
    
    [slingPlayerOne createSlingForPlayerIndex: 1];
    [slingPlayerTwo createSlingForPlayerIndex: 2];
    
    NVTransformable* instructionsPlayerOneTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: @"player_one_instructions"];
    NVTransformable* instructionsPlayerTwoTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: @"player_two_instructions"];
    
    kmVec3 instructionsPlayerOnePosition;
    kmVec3Fill(&instructionsPlayerOnePosition, 0, -(playingFieldScale.y / 2) + 2.0f, 0.1f);
    
    instructionsPlayerOneTransform.position = instructionsPlayerOnePosition;

    kmVec3 instructionsPlayerTwoPosition;
    kmVec3Fill(&instructionsPlayerTwoPosition, 0, (playingFieldScale.y / 2) - 2.0f, 0.1f);
    
    instructionsPlayerTwoTransform.position = instructionsPlayerTwoPosition;
    
    kmVec3 instructionsPlayerTwoRotationAxis;
    kmVec3Fill(&instructionsPlayerTwoRotationAxis, 0, 0, 1);
    
    kmQuaternion instructionsPlayerTwoRotation;
    kmQuaternionRotationAxis(&instructionsPlayerTwoRotation, &instructionsPlayerTwoRotationAxis, kmDegreesToRadians(180.0f));
    
    instructionsPlayerTwoTransform.rotation = instructionsPlayerTwoRotation;
    
    SBRotateAroundAxis* rotateCamera = [[SBRotateAroundAxis alloc] init];
    rotateCamera.speed = 0.5f;
    kmVec3Fill(rotateCamera.axis, 0, 0, 1);
    [self.database bindComponent: rotateCamera toGroup: kGroupCamera];
    [rotateCamera release];

    [self unbindAndCommit];
}

@end
