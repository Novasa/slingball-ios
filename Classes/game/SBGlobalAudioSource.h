//
//  SBGlobalAudioSource.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"
#import "NVInterpolatorDelegate.h"

extern NSString* const kAudioWallCollision;
extern NSString* const kAudioSlingCollision;
extern NSString* const kAudioGoal;
extern NSString* const kAudioGoalOwn;
extern NSString* const kAudioMenuTap;
extern NSString* const kAudioExplosion;

extern NSString* const kAudioBackgroundMusic;

@interface SBGlobalAudioSource : NVComponent <NVInterpolatorDelegate> {
 @private
    float _maxMusicVolume;
    float _maxEffectVolume;
}

@end
