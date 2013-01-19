//
//  NVDebugService.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/19/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#ifdef DEBUG
#import "NVDebugService.h"
#import "NVComponent.h"
#import "NVGame.h"

#import <objc/runtime.h>

@implementation NVDebugService

- (id) init {
    if (self = [super init]) {
        _serviceableComponents = [[NSMutableArray alloc] init];
        
        _shouldCheckForDirtyDependencies = YES;
        _shouldCheckForMissingDependencies = YES;
        
        _shouldPrintStatistics = YES;
        
        _timeBetweenChecks = 5; // in seconds
        _timeInitiatedPreviousCheck = 0;
    }
    return self;
}

- (BOOL) isDependencyDirty: (NVComponent*) component {
    return component == nil || component.database == nil || (component.group == nil || component.group.length == 0);
}

- (void) checkMissingDependenciesForComponent: (NVComponent*) component {
    unsigned int varCount;
	
	Ivar *vars = class_copyIvarList([component class], &varCount);
	
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
				id currentValue;
                
				object_getInstanceVariable(component, name, (void*)&currentValue);
				
				if (currentValue == nil) {
                    for (int j = 0; j < varCount; j++) {
                        Ivar otherVar = vars[j];
                        
                        const char* otherVarName = ivar_getName(otherVar);
                        
                        NSString* requiresLocally = [NSString stringWithFormat: @"__requires_%s", name];
                        NSString* requiresFromGroup = [NSString stringWithFormat: @"__requires_%s_from_group_", name];
                        
                        NSString* convertedOtherVarName = [NSString stringWithCString: otherVarName encoding: [NSString defaultCStringEncoding]];
                        
                        if ([convertedOtherVarName caseInsensitiveCompare: requiresLocally] == NSOrderedSame) {
                            Debug((@"DEBUG: WARNING - Component %@ in group [%@] is missing a reference to a required "
                                   "local dependency of type %@", component, component.group, type));
                            
                            break;
                        } else {
                            if (convertedOtherVarName.length > requiresFromGroup.length) {
                                NSString* sub = [convertedOtherVarName substringToIndex: requiresFromGroup.length];
                                
                                if ([sub caseInsensitiveCompare: requiresFromGroup] == NSOrderedSame) {
                                    NSString* dependentGroupName = [convertedOtherVarName substringFromIndex: requiresFromGroup.length];
                                    
                                    Debug((@"DEBUG: WARNING - Component %@ in group [%@] is missing a reference to a required remote "
                                           "dependency of type %@ from group [%@]", component, component.group, type, dependentGroupName));
                                    
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    free(vars);
}

- (void) tick {
    float now = current_time();
    float timeSincePreviousCheck = now - _timeInitiatedPreviousCheck;
    
    if (timeSincePreviousCheck > _timeBetweenChecks) {
        NVComponentDatabase* db = [[NVGame sharedGame] database];
        
        Debug((@"DEBUG Statistics:"));
        Debug((@"  currently servicing %u components in %u groups", [db debugGetComponentCount], [db debugGetGroupCount]));
        
        _timeInitiatedPreviousCheck = now;
        
        for (int i = 0; i < _serviceableComponents.count; i++) {
            NVComponent* component = [_serviceableComponents objectAtIndex: i];
            
            if (_shouldCheckForDirtyDependencies) {
                NSArray* dependencies = [component debugGetDependencies];
                
                for (int j = 0; j < dependencies.count; j++) {
                    NVComponent* dependency = [dependencies objectAtIndex: j];
                    
                    if ([self isDependencyDirty: dependency]) {
                        Debug((@"DEBUG: WARNING - Component %@ in group [%@] has a dirty dependency %@ (the "
                               "component is not bound to any database)", component, component.group, dependency));
                    }
                }
            }
            
            if (_shouldCheckForMissingDependencies) {
                [self checkMissingDependenciesForComponent: component];
            }
        }
    }
}

- (BOOL) isInterestedInComponent: (NVComponent*) component {
    return YES;
}

- (void) database: (NVComponentDatabase*) database didBind: (NVComponent*) component {
    if (![_serviceableComponents containsObject: component]) {
        [_serviceableComponents addObject: component];
    }
}

- (void) database: (NVComponentDatabase*) database didUnbind: (NVComponent*) component {
    if ([_serviceableComponents containsObject: component]) {
        [_serviceableComponents removeObject: component];
    }
}

- (void) dealloc {
    [_serviceableComponents release];
    
    [super dealloc];
}

@end
#endif
