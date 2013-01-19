//
//  NVScene.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/21/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponentDatabase.h"

#import "NVLoadableAsync.h"

@interface NVScene : NSObject <NVLoadableAsync> {
 @private
    NVComponentDatabase* _database;
    
    NSString* _filename;
    NSString* _name;
    
    NSMutableArray* _groups;
    NSMutableArray* _components;
}

@property(nonatomic, readonly) NSString* name;

- (id) initWithFileNamed: (NSString*) file andDatabase: (NVComponentDatabase*) database;

@end

