/*
 *  NVComponentDatabaseService.h
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 11/17/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

@class NVComponentDatabase;
@class NVComponent;

@protocol NVComponentDatabaseService <NSObject>
@required
- (BOOL) isInterestedInComponent: (NVComponent*) component;
@optional
- (void) database: (NVComponentDatabase*) database didBind: (NVComponent*) component;
- (void) database: (NVComponentDatabase*) database didUnbind: (NVComponent*) component;
@end
