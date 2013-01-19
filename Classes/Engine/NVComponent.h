//
//  NVComponent.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/17/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponentDatabase.h"

/**
 * Creates a mutable array which does not retain references to the objects it contains.
 */
NSMutableArray* TTCreateNonRetainingArray();

@interface NVComponent : NSObject {
 @private
	NVComponentDatabase* _database;

    NSMutableArray* _dependencies;

	NSString* _group;
    NSString* _tag;
    
	BOOL _isEnabled;
    BOOL _isLocked;
}

@property(nonatomic, readonly) NVComponentDatabase* database;
@property(nonatomic, readonly) NSString* group;

@property(nonatomic, readwrite, copy) NSString* tag;
@property(nonatomic, readwrite, assign) BOOL isEnabled;
@property(nonatomic, readwrite, assign) BOOL isLocked;

+ (BOOL) classIsComponent: (Class) cls;
// TODO: rename start and end; e.g. open/begin close/dispose

- (void) start;
- (void) end;

- (void) didChangeEnability;
- (void) didLock: (BOOL) locked;

- (void) unbind;
- (void) unbindAndCommit;

#ifdef DEBUG
- (NSArray*) debugGetDependencies;
#endif

@end
