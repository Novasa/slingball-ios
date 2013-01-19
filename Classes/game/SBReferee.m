//
//  SBReferee.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBReferee.h"

#import "NVAudioCache.h"

#import "SBGroups.h"
#import "SBGlobalAudioSource.h"
#import "SBBallExplosionParticlesController.h"

#import "SBUIMenuController.h"

@implementation SBReferee

- (id) init { 
    if (self = [super init]) {
        _timeDurationBeforeResettingBall = 0.75f;
    }
    return self;
}

- (void) start {
    [super start];
    
    _playerOneGoalController.delegate = self;
    _playerTwoGoalController.delegate = self;
}

- (void) resetGame {
    [_scoreboardController reset];
    
    [_ballController reset];
    
    [_playerOneSling restoreInitialState];
    [_playerTwoSling restoreInitialState];
    
    _playerOneHead.isVisible = YES;
    _playerTwoHead.isVisible = YES;
    
    _playerOneSlingController.acceptsInput = YES;
    _playerTwoSlingController.acceptsInput = YES;
    
    _sweepController.isEnabled = NO;
}

- (void) initiateWinReset {
    // NOTE: hacky solution to force-navigating to main menu, since all menu items are toggles, 
    // things would get WEIRD if we only clicked menu in this scenario
    SBUIMenuController* dockMenuController = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_dock"];
    SBUIMenuController* menuMenuController = [self.database getComponentOfAnyType: [SBUIMenuController class] fromGroup: @"menu_menu"];
    
    [dockMenuController didClick];
    [menuMenuController didClick];
    
    [_sweepController sweepForPlayerIndex: _winnerIndex == 1 ? 2 : 1];
}

- (void) initiateWin {
    [_floatingTextController displayFloatingText: SBFloatingTextElementYouWin forPlayerIndex: _winnerIndex];
    
    [self performSelector: @selector(initiateWinReset) withObject: nil afterDelay: 1];
}

- (void) announceOwnGoalForPlayerIndex: (NSUInteger) index {
    [_floatingTextController displayFloatingText: SBFloatingTextElementOwnGoal forPlayerIndex: index];
    
    [[NVAudioCache sharedCache] playSoundWithKey: kAudioGoalOwn gain: 1.0f pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
}

- (void) announceGoalForPlayerIndex: (NSUInteger) index {
    [_floatingTextController displayFloatingText: SBFloatingTextElementGoal forPlayerIndex: index];
    
    [[NVAudioCache sharedCache] playSoundWithKey: kAudioGoal gain: 1.0f pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
}

- (BOOL) isWaitingToResetBall {
    return _isWaitingToResetBall;
}

- (void) resetBall {
    SBBallExplosionParticlesController* ballExplosion = [_ballCollider.database getComponentOfType: [SBBallExplosionParticlesController class] 
                                                                                         fromGroup: _ballCollider.group];
    
    [ballExplosion reset];
    
    ballExplosion.isEnabled = YES;

    [[NVAudioCache sharedCache] playSoundWithKey: kAudioExplosion gain: 1.0f pitch: 1.0f location: CGPointZero shouldLoop: NO sourceID: -1];
    
    [_ballController reset];
    
    _isWaitingToResetBall = NO;
}

- (void) goalDidCatchBall: (SBGoalController*) goal {
    _isWaitingToResetBall = YES;
    
    [self performSelector: @selector(resetBall) 
               withObject: nil 
               afterDelay: _timeDurationBeforeResettingBall];
    
    static NSUInteger const maxScore = 3;
    
    if ([goal.tag caseInsensitiveCompare: kGroupPlayerOne] == NSOrderedSame) {
        /*if (_ballCollider.mostRecentCollider == _playerOneCollider) {
            [self announceOwnGoalForPlayerIndex: 1];
            
            if ([_scoreboardController scoreForPlayerIndex: 1] > 0) {
                [_scoreboardController decreaseScoreForPlayerIndex: 1];   
            }
        } else {*/
            [self announceGoalForPlayerIndex: 2];
            
            if ([_scoreboardController scoreForPlayerIndex: 2] < maxScore) {            
                [_scoreboardController increaseScoreForPlayerIndex: 2];
                
                if ([_scoreboardController scoreForPlayerIndex: 2] == maxScore) {
                    _winnerIndex = 2;
                    
                    [self performSelector: @selector(initiateWin) withObject: nil afterDelay: 1.15f];
                }
            }
        //}
    } else if ([goal.tag caseInsensitiveCompare: kGroupPlayerTwo] == NSOrderedSame) {        
        /*if (_ballCollider.mostRecentCollider == _playerTwoCollider) {
            [self announceOwnGoalForPlayerIndex: 2];
            
            if ([_scoreboardController scoreForPlayerIndex: 2] > 0) {
                [_scoreboardController decreaseScoreForPlayerIndex: 2];
            }
        } else {*/
            [self announceGoalForPlayerIndex: 1];
            
            if ([_scoreboardController scoreForPlayerIndex: 1] < maxScore) {
                [_scoreboardController increaseScoreForPlayerIndex: 1];
                
                if ([_scoreboardController scoreForPlayerIndex: 1] == maxScore) {
                    _winnerIndex = 1;
                    
                    [self performSelector: @selector(initiateWin) withObject: nil afterDelay: 1.15f];
                }
            }
        //}
    }
}

@end
