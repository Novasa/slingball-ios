//
//  SBReferee.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponent.h"

#import "SBGoalController.h"
#import "SBGoalControllerDelegate.h"

#import "SBScoreBoardController.h"

#import "SBSlingHeadCollider.h"
#import "SBSlingHead.h"
#import "SBSlingController.h"
#import "SBSlingBody.h"

#import "SBBallController.h"
#import "SBBallCollider.h"

#import "SBFloatingTextController.h"

#import "SBPlayingFieldSweepController.h"

@interface SBReferee : NVComponent <SBGoalControllerDelegate> {
 @private
    REQUIRES_FROM_GROUP(SBScoreBoardController, _scoreboardController, scoreboard);
    
    REQUIRES_FROM_GROUP(SBBallController, _ballController, ball);
    REQUIRES_FROM_GROUP(SBBallCollider, _ballCollider, ball);
    
    REQUIRES_FROM_GROUP(SBSlingHeadCollider, _playerOneCollider, player_one);
    REQUIRES_FROM_GROUP(SBSlingHeadCollider, _playerTwoCollider, player_two);
    REQUIRES_FROM_GROUP(SBSlingHead, _playerOneHead, player_one);
    REQUIRES_FROM_GROUP(SBSlingHead, _playerTwoHead, player_two);
    REQUIRES_FROM_GROUP(SBSlingController, _playerOneSlingController, player_one);
    REQUIRES_FROM_GROUP(SBSlingController, _playerTwoSlingController, player_two);
    REQUIRES_FROM_GROUP(SBSlingBody, _playerOneSling, player_one);
    REQUIRES_FROM_GROUP(SBSlingBody, _playerTwoSling, player_two);    
    
    REQUIRES_FROM_GROUP(SBGoalController, _playerOneGoalController, player_one_goal);
    REQUIRES_FROM_GROUP(SBGoalController, _playerTwoGoalController, player_two_goal);
    
    REQUIRES_FROM_GROUP(SBFloatingTextController, _floatingTextController, floating_text);
    
    REQUIRES_FROM_GROUP(SBPlayingFieldSweepController, _sweepController, playing_field_sweep);
    
    BOOL _isWaitingToResetBall;
    
    NSUInteger _winnerIndex;
    
    float _timeDurationBeforeResettingBall;
}

- (void) resetGame;

@end
