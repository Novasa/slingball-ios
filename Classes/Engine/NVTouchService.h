//
//  NVTouchService.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/15/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponentDatabaseService.h"
#import "NVTouchable.h"

@interface NVTouchService : NSObject <NVComponentDatabaseService, NVTouchable> {
 @private
    NSMutableArray* _touchables;
}

@end
