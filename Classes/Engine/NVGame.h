//
//  NVGame.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVComponentDatabase.h"
#import "NVSchedulingService.h"
#import "NVRenderingService.h"
#import "NVTransformationService.h"
#import "NVScene.h"
#import "NVLoadableAsyncDelegate.h"

@interface NVGame : NSObject <NVLoadableAsyncDelegate> {
 @private
    NVComponentDatabase* _database;
    
    NVSchedulingService* _scheduling;
    NVRenderingService* _rendering;
    NVTransformationService* _transformation;

    NSMutableArray* _loadedScenes;
    
    NSMutableArray* _queuedScenesForLoad;
    NSMutableArray* _queuedScenesForUnload;
}

+ (NVGame*) sharedGame;

@property(nonatomic, readonly) NVComponentDatabase* database;
@property(nonatomic, readonly) NVSchedulingService* scheduling;
@property(nonatomic, readonly) NVRenderingService* rendering;
@property(nonatomic, readonly) NVTransformationService* transformation;

- (void) loadScene: (NVScene*) scene;
- (void) loadSceneAdditively: (NVScene*) scene;
- (void) loadSceneAsync: (NVScene*) scene;
- (void) loadSceneAdditivelyAsync: (NVScene*) scene;

- (NSUInteger) scenesLoaded;

- (void) unloadSceneAtIndex: (NSUInteger) index;
- (void) unloadSceneNamed: (NSString*) name;

- (void) flushScenes;

- (void) loadSceneFromFileNamed: (NSString*) file async: (BOOL) async;
- (void) loadSceneAdditivelyFromFileNamed: (NSString*) file async: (BOOL) async;

@end
