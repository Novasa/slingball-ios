//
//  SBScoreBoardController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/9/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"

@interface SBScoreBoardController : NVSchedulable {
 @private    
    NSUInteger _playerOneScore;
    NSUInteger _playerTwoScore;
}

- (void) increaseScoreForPlayerIndex: (NSUInteger) index;
- (void) decreaseScoreForPlayerIndex: (NSUInteger) index;

- (NSUInteger) scoreForPlayerIndex: (NSUInteger) index;

- (void) reset;

@end
