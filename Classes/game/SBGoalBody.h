//
//  SBGoalBody.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/22/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVSoftSpringBody.h"

@interface SBGoalBody : NVSoftSpringBody {

}

- (void) createGoalForPlayerIndex: (NSUInteger) index;

@end
