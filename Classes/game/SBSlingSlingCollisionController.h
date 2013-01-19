//
//  SBSlingSlingCollisionController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/12/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSchedulable.h"

#import "SBSlingHeadCollider.h"

@interface SBSlingSlingCollisionController : NVSchedulable {
 @private
    REQUIRES_FROM_GROUP(SBSlingHeadCollider, _playerOneHead, player_one);
    REQUIRES_FROM_GROUP(SBSlingHeadCollider, _playerTwoHead, player_two);
}

@end
