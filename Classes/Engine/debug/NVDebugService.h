//
//  NVDebugService.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/19/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#ifdef DEBUG
#import <Foundation/Foundation.h>

#import "NVComponentDatabaseService.h"

@interface NVDebugService : NSObject <NVComponentDatabaseService> {
 @private
    NSMutableArray* _serviceableComponents;
    
    BOOL _shouldCheckForDirtyDependencies;
    BOOL _shouldCheckForMissingDependencies;
    
    BOOL _shouldPrintStatistics;
    
    float _timeBetweenChecks;
    float _timeInitiatedPreviousCheck;
}

- (void) tick;

@end
#endif
