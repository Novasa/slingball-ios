//
//  NVComponent.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/17/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVComponent.h"

#import <objc/runtime.h>

static const void* TTRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void TTReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

NSMutableArray* TTCreateNonRetainingArray() {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = TTRetainNoOp;
    callbacks.release = TTReleaseNoOp;
    return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}

@implementation NVComponent

+ (BOOL) classIsComponent: (Class) cls {
	Class target = [NVComponent class];
	Class superclass = cls;
	
	BOOL isComponent = NO;
    
    while (!isComponent && superclass != nil) {
        isComponent = superclass == target;
        
        superclass = class_getSuperclass(superclass);
    }
    
	return isComponent;
}

@dynamic database;
@dynamic isEnabled;
@dynamic isLocked;
@dynamic group;
@synthesize tag = _tag;

- (id) init {
    if (self = [super init]) {
        _isEnabled = YES;
        
        _dependencies = TTCreateNonRetainingArray();
    }
    return self;
}

- (void) unbind {
    if (_database != nil) {
        [_database unbindComponent: self];
    }
}

- (void) unbindAndCommit {
    if (_database != nil) {
        // store a new reference to it, since unbinding will trigger a setInstanceVariable(nil) on _database
        NVComponentDatabase* db = [_database retain];
        
        [_database unbindComponent: self];
        
        [db commit];
        [db release];
    }
}

- (NSUInteger) findAndInjectDependenciesForClass: (Class) class recursively: (BOOL) recursively {
    NSUInteger dependenciesFound = 0;
    
    if (recursively) {
        Class superclass = class_getSuperclass(class);
        
        if ([NVComponent classIsComponent: superclass]) {
            dependenciesFound += [self findAndInjectDependenciesForClass: superclass 
                                                             recursively: recursively];
        }
    }
    
    unsigned int varCount;
	
	Ivar *vars = class_copyIvarList(class, &varCount);
	
	for (int i = 0; i < varCount; i++) {
		Ivar var = vars[i];
		
		const char* name = ivar_getName(var);
		const char* typeEncoding = ivar_getTypeEncoding(var);
        
		NSMutableString* type = [NSMutableString stringWithCString: typeEncoding
                                                          encoding: [NSString defaultCStringEncoding]];
        
		[type replaceOccurrencesOfString:@"\"" withString:@"" options: 0 range: NSMakeRange(0, [type length])];
		[type replaceOccurrencesOfString:@"@" withString:@"" options: 0 range: NSMakeRange(0, [type length])];
		
		id cls = objc_lookUpClass([type UTF8String]);
		
		if (cls != nil) {
			if ([NVComponent classIsComponent: cls]) {
                // we only want to inject if field is nil
				id currentValue;
                
				object_getInstanceVariable(self, name, (void*)&currentValue);
				
				if (currentValue == nil) {
                    BOOL shouldProceedWithInjection = NO;
                    
                    // defaulting to local injections
                    NSString* targetGroup = _group;
                    
                    for (int j = 0; j < varCount; j++) {
                        Ivar otherVar = vars[j];
                        
                        const char* otherVarName = ivar_getName(otherVar);
    
                        NSString* requiresLocally = [NSString stringWithFormat: @"__requires_%s", name];
                        NSString* requiresFromGroup = [NSString stringWithFormat: @"__requires_%s_from_group_", name];
                        
                        NSString* convertedOtherVarName = [NSString stringWithCString: otherVarName encoding: [NSString defaultCStringEncoding]];
                        
                        if ([convertedOtherVarName caseInsensitiveCompare: requiresLocally] == NSOrderedSame) {
                            // local injection
                            shouldProceedWithInjection = YES;
                            
                            break;
                        } else {
                            // remote injection
                            if (convertedOtherVarName.length > requiresFromGroup.length) {
                                NSString* sub = [convertedOtherVarName substringToIndex: requiresFromGroup.length];
                                
                                if ([sub caseInsensitiveCompare: requiresFromGroup] == NSOrderedSame) {
                                    NSString* dependentGroupName = [convertedOtherVarName substringFromIndex: requiresFromGroup.length];
                                    
                                    shouldProceedWithInjection = YES;
                                    
                                    targetGroup = dependentGroupName;
                                    
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (shouldProceedWithInjection) {
                        dependenciesFound++;

                        if ([_database componentOfType: cls isBoundToGroup: targetGroup]) {
                            NVComponent* exists = [_database getComponentOfType: cls 
                                                                      fromGroup: targetGroup];
                            
                            object_setInstanceVariable(self, name, exists);
                            
                            [_dependencies addObject: exists];
                        } else {
                            if ([_database componentOfAnyType: cls isBoundToGroup: targetGroup]) {
                                NVComponent* exists = [_database getComponentOfAnyType: cls 
                                                                             fromGroup: targetGroup];
                                
                                object_setInstanceVariable(self, name, exists);
                                
                                [_dependencies addObject: exists];
                                
                                Debug((@"COMPONENT: INFO - A subclass (%@) of the specified dependency (%@) "
                                       "was found already bound to group \"%@\". This reference was injected "
                                       "into the dependency field.", exists, cls, targetGroup));                                
                            } else {
                                id injection = class_createInstance(cls, class_getInstanceSize(cls));                                
                                
                                [_dependencies addObject: injection];
                                
                                object_setInstanceVariable(self, name, injection);
                                
                                [injection init];
                                
                                [_database bindComponent: injection 
                                                 toGroup: targetGroup];
                                
                                [injection release];
                            }
                        }
                    }
				}
			}
		}
	}
	
	free(vars);
    
    return dependenciesFound;
}

- (void) start {
    /*NSUInteger dependenciesFound = */[self findAndInjectDependenciesForClass: [self class] 
                                                                   recursively: YES];
}

- (void) end {
    
}

- (NVComponentDatabase*) database {
	return _database;
}

- (NSString*) group {
	return _group;
}

- (BOOL) isEnabled {
	return _isEnabled;
}

- (void) setIsEnabled: (BOOL) value {
	if (_isEnabled != value) {
		_isEnabled = value;
        
        [self didChangeEnability];
	}
}

- (BOOL) isLocked {
    return _isLocked;
}

- (void) setIsLocked: (BOOL) value {
	if (_isLocked != value) {
		_isLocked = value;
        
        if (_isLocked) {
            for (NVComponent* dependency in _dependencies) {
                dependency.isLocked = YES;
            }
        }
        
        [self didLock: _isLocked];
	}
}

- (void) didChangeEnability { }
- (void) didLock: (BOOL) locked { }

#ifdef DEBUG
- (NSArray*) debugGetDependencies {
    return _dependencies;
}
#endif

- (void) dealloc {
    _isEnabled = false;
    
    if (_database != nil) {
        [_database release];
        _database = nil;
    }
    
    if (_group != nil) {
        [_group release];
        _group = nil;
    }
    
    if (_dependencies != nil) {
        CFRelease(_dependencies);
    
        _dependencies = nil;
    }
    
	[super dealloc];
}

@end

