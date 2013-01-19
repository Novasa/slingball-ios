//
//  NVComponentDatabase.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/17/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponentDatabaseService.h"

@class NVComponent;

@interface NVComponentDatabase : NSObject {
 @private
	NSMutableDictionary* _container;
    NSMutableArray* _services;
    
    NSMutableArray* _nonCommittedComponents;
    
#ifdef DEBUG
    NSUInteger _debugComponentCount;
#endif
}

- (void) bindComponent: (NVComponent*) component toGroup: (NSString*) group;
- (void) bindComponent: (NVComponent*) component toGroupAndCommit: (NSString*) group;
- (void) unbindComponent: (NVComponent*) component;
- (void) unbindComponent: (Class) type fromGroup: (NSString*) group;
- (void) unbindComponentAndCommit: (NVComponent*) component;
- (void) unbindAllComponentsFromGroup: (NSString*) group;

- (id) getComponentOfType: (Class) type fromGroup: (NSString*) group;
- (id) getComponentOfAnyType: (Class) type fromGroup: (NSString*) group;

- (void) commit;

- (NSArray*) allComponents;
- (NSArray*) allComponentsForGroup: (NSString*) group;
- (NSArray*) allComponentsForGroup: (NSString*) group ofAnyType: (Class) type;
- (NSArray*) allComponentsOfType: (Class) type;

- (BOOL) componentOfType: (Class) type isBoundToGroup: (NSString*) group;
- (BOOL) componentOfAnyType: (Class) type isBoundToGroup: (NSString*) group;

- (void) subscribeService: (id<NVComponentDatabaseService>) service;
- (void) unsubscribeService: (id<NVComponentDatabaseService>) service;

#ifdef DEBUG
- (void) debugPrintContents;
- (void) debugPrintServicesPretty;
- (void) debugPrintComponentsPretty;
- (NSUInteger) debugGetComponentCount;
- (NSUInteger) debugGetGroupCount;
#endif

@end
