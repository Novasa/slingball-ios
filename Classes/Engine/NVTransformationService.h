//
//  NVTransformationService.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/20/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponentDatabaseService.h"

@interface NVTransformationService : NSObject <NVComponentDatabaseService> {
 @private
    NSMutableArray* _transformables;
    
    SEL resolve_func_selector;
}

- (void) resolve;

@end
