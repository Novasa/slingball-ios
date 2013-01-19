//
//  NVRenderingService.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/10/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponentDatabaseService.h"

@interface NVRenderingService : NSObject <NVComponentDatabaseService> {
 @private
    NSMutableArray* _renderables;
    
    NSSortDescriptor* _sortDescriptorRenderKey;
    
    NSArray* _sortDescriptors;
    
    SEL render_func_selector;
    
    unsigned int _currentlyEnabledState;
}

- (void) render;

#ifdef DEBUG
- (void) debug_printRenderableOrder;
#endif

@end
