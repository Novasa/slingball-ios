//
//  SBGlobalAudioSource.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBGlobalAudioSource.h"

#import "NVGame.h"
#import "NVAudioCache.h"
#import "NVInterpolator.h"

NSString* const kAudioWallCollision = @"wall_collision";
NSString* const kAudioSlingCollision = @"sling_collision";
NSString* const kAudioGoal = @"goal";
NSString* const kAudioGoalOwn = @"goal_own";
NSString* const kAudioMenuTap = @"menu_tap";
NSString* const kAudioExplosion = @"explosion";

NSString* const kAudioBackgroundMusic = @"background_ambience";

@implementation SBGlobalAudioSource

- (id) init {
    if (self = [super init]) {
        _maxMusicVolume = 0.75f;
        _maxEffectVolume = 1.0f;
    }
    return self;
}

- (void) interpolatorDidStep: (NVInterpolator*) interpolator {
    float weight = interpolator.weight;
    
    [[NVAudioCache sharedCache] setFxVolume: _maxEffectVolume * weight];
    [[NVAudioCache sharedCache] setMusicVolume: _maxMusicVolume * weight];
}

- (void) start {
    [super start];
    
    [[NVAudioCache sharedCache] loadBackgroundMusicWithKey: kAudioBackgroundMusic musicFile: @"Relaxing_Wires_04.mp3"];
    
    [[NVAudioCache sharedCache] loadSoundWithKey: kAudioMenuTap musicFile: @"013_Pickup.caf"];
    [[NVAudioCache sharedCache] loadSoundWithKey: kAudioWallCollision musicFile: @"001_Empty.caf"];
    [[NVAudioCache sharedCache] loadSoundWithKey: kAudioSlingCollision musicFile: @"009_Hit.caf"];
    [[NVAudioCache sharedCache] loadSoundWithKey: kAudioGoal musicFile: @"015_Powerup.caf"];
    [[NVAudioCache sharedCache] loadSoundWithKey: kAudioGoalOwn musicFile: @"022_Powerup.caf"];
    [[NVAudioCache sharedCache] loadSoundWithKey: kAudioExplosion musicFile: @"035_Explosion.caf"];
    
    [[NVAudioCache sharedCache] setFxVolume: 0.0f];
    [[NVAudioCache sharedCache] setMusicVolume: 0.0f];
    
    [[NVAudioCache sharedCache] playMusicWithKey: kAudioBackgroundMusic timesToRepeat: -1];
    
    NVInterpolator* interpolator = [[[NVGame sharedGame] scheduling] nextAvailableInterpolator];
    
    if (interpolator != nil) {
        interpolator.duration = 10;
        [interpolator beginWithDelegate: self];
    }
}

- (void) end {
    // unload sounds
}

@end
