//
//  NVGame.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVGame.h"

#import "SynthesizeSingleton.h"

float GLOBAL_TIME_SCALE = 1.0f;

@implementation NVGame

@synthesize database = _database;
@synthesize scheduling = _scheduling;
@synthesize rendering = _rendering;
@synthesize transformation = _transformation;

SYNTHESIZE_SINGLETON_FOR_CLASS(NVGame, Game);

- (id) init {
    if (self = [super init]) {
        _database = [[NVComponentDatabase alloc] init];
        
        _scheduling = [[NVSchedulingService alloc] init];
        _rendering = [[NVRenderingService alloc] init];
        _transformation = [[NVTransformationService alloc] init];
                
        [_database subscribeService: _scheduling];
        [_database subscribeService: _rendering];
        [_database subscribeService: _transformation];
        
        _loadedScenes = [[NSMutableArray alloc] init];
        
        _queuedScenesForLoad = [[NSMutableArray alloc] init];
        _queuedScenesForUnload = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) loadScene: (NVScene*) scene {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [self flushScenes];
    
    [scene loadWithDelegate: self];
    
    [pool release];
}

- (void) loadSceneAdditively: (NVScene*) scene {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [scene loadWithDelegate: self];
    
    [pool release];
}

- (void) loadSceneAsync: (NVScene*) scene {
    if (![_queuedScenesForLoad containsObject: scene]) {
        [_queuedScenesForLoad addObject: scene];
        
        [self performSelectorInBackground: @selector(loadScene:) 
                               withObject: scene];
    }
}

- (void) loadSceneAdditivelyAsync: (NVScene*) scene {
    if (![_queuedScenesForLoad containsObject: scene]) {
        [_queuedScenesForLoad addObject: scene];
        
        [self performSelectorInBackground: @selector(loadSceneAdditively:) 
                               withObject: scene];
    }
}

- (void) loadSceneFromFileNamed: (NSString*) file async: (BOOL) async {
    NVScene* scene = [[NVScene alloc] initWithFileNamed: file andDatabase: _database];

    if (async) {
        [self loadSceneAsync: scene];
    } else {
        [self loadScene: scene];
    }
    
    [scene release];
}

- (void) loadSceneAdditivelyFromFileNamed: (NSString*) file async: (BOOL) async {
    NVScene* scene = [[NVScene alloc] initWithFileNamed: file andDatabase: _database];
    
    if (async) {
        [self loadSceneAdditivelyAsync: scene];
    } else {
        [self loadSceneAdditively: scene];
    }
    
    [scene release];    
}

- (NSUInteger) scenesLoaded {
    return [_loadedScenes count];
}

- (void) unloadSceneAtIndex: (NSUInteger) index {
    if (index < _loadedScenes.count) {
        NVScene* scene = [_loadedScenes objectAtIndex: index];
        
        [scene unloadWithDelegate: self]; 
    }
}

- (void) unloadSceneNamed: (NSString*) name {
    NVScene* sceneToUnload = nil;
    
    for (NVScene* scene in _loadedScenes) {
        if ([scene.name caseInsensitiveCompare: name] == NSOrderedSame) {
            sceneToUnload = scene;
            
            break;
        }
    }
    
    if (sceneToUnload != nil) {
        [self unloadSceneAtIndex: 
         [_loadedScenes indexOfObject: sceneToUnload]];
    }
}

- (void) flushScenes {
    for (int i = _loadedScenes.count - 1; i >= 0; i--) {
        [self unloadSceneAtIndex: i];
    }
}

- (void) loadableDidLoad: (id<NVLoadableAsync>) loadable {
    @synchronized(_loadedScenes) {
        if (![_loadedScenes containsObject: loadable]) {
            [_loadedScenes addObject: loadable];
        }
    }
    
    @synchronized(_queuedScenesForLoad) {
        if (_queuedScenesForLoad.count > 0) {
            if ([_queuedScenesForLoad containsObject: loadable]) {
                [_queuedScenesForLoad removeObject: loadable];
            }
        }
    }
    
    [_database commit];
}

- (void) loadableDidUnload: (id<NVLoadableAsync>) loadable {
    @synchronized(_loadedScenes) {
        if ([_loadedScenes containsObject: loadable]) {
            [_loadedScenes removeObject: loadable];
        }
    }
        
    [_database commit];
}

- (void) dealloc {
    [self flushScenes];
    
    [_loadedScenes release];
    
    [_queuedScenesForLoad release];
    [_queuedScenesForUnload release];
    
    [_database release];
    [_scheduling release];
    [_rendering release];
    [_transformation release];
    
    [super dealloc];
}
@end
