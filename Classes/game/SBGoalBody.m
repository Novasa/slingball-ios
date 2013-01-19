//
//  SBGoalBody.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBGoalBody.h"

#import "SBPlayingFieldController.h"

@implementation SBGoalBody

- (void) createGoalForPlayerIndex: (NSUInteger) index {    
    if (index == 0) {
        return;
    }
    
    SBPlayingFieldController* playingFieldController = [self.database getComponentOfType: [SBPlayingFieldController class] 
                                                                               fromGroup: @"playing_field"];

    float x = playingFieldController.goalWidth / 2;
    float h = playingFieldController.height / 2;
    float y = index == 1 ? -h : h;
    
    kmVec3 leftPosition;
    kmVec3Fill(&leftPosition, -x, y, 0);
    
    kmVec3 rightPosition;
    kmVec3Fill(&rightPosition, x, y, 0);
    
    NVSpringParticle* left = [self createParticleAtPosition: leftPosition];
    
    NSUInteger segments = 8;
    
    float distanceBetweenPoints = fabs(leftPosition.x - rightPosition.x) / (segments + 1);
    float xoffset = leftPosition.x;
    
    NVSpringParticle* previousParticle = left;
    
    for (int i = 0; i < segments; i++) {
        xoffset += distanceBetweenPoints;
        
        kmVec3 segmentEndPosition;
        kmVec3Fill(&segmentEndPosition, xoffset, y, 0);
        
        NVSpringParticle* segment = [self createParticleAtPosition: segmentEndPosition];
        
        [self connectParticle: previousParticle withParticle: segment];
        
        previousParticle = segment;
    }
    
    NVSpringParticle* right = [self createParticleAtPosition: rightPosition];
    
    [self connectParticle: previousParticle withParticle: right];
    
    [self createParticleAnchorWithParticle: left];
    [self createParticleAnchorWithParticle: right];
}

@end
