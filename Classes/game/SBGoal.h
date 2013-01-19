//
//  SBGoal.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/5/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "SBGoalBody.h"

@interface SBGoal : NVRenderable {
 @private
    REQUIRES(SBGoalBody, _body);
}

@end
