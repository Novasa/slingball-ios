//
//  SBScoreBoardController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/9/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBScoreBoardController.h"

@implementation SBScoreBoardController

- (id) init {
    if (self = [super init]) {
        [self reset];
    }
    return self;
}

- (void) reset {
    _playerOneScore = 0;
    _playerTwoScore = 0;
}

- (void) increaseScoreForPlayerIndex: (NSUInteger) index {
    switch (index) {
        case 1: _playerOneScore++; break;
        case 2: _playerTwoScore++; break;
            
        default: break;
    }
}

- (void) decreaseScoreForPlayerIndex: (NSUInteger) index {
    switch (index) {
        case 1: if (_playerOneScore > 0) { _playerOneScore--; } break;
        case 2: if (_playerTwoScore > 0) { _playerTwoScore--; } break;
            
        default: break;
    }        
}

- (NSUInteger) scoreForPlayerIndex: (NSUInteger) index {
    switch (index) {
        case 1: {
            return _playerOneScore;
        } break;
            
        case 2: {
            return _playerTwoScore;
        } break;
            
        default: break;
    }
    
    return 0;
}

@end
