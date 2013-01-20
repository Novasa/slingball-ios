//
//  NVComponentDatabase.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 11/17/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVComponentDatabase.h"
#import "NVComponent.h"

#import <objc/runtime.h>

@implementation NVComponentDatabase

- (id) init {
    if (self = [super init]) {
        _container = [[NSMutableDictionary alloc] init];
        _services = [[NSMutableArray alloc] init];
        
        _nonCommittedComponents = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) addComponentToCommitQueue: (NVComponent*) component {
    if (![_nonCommittedComponents containsObject: component]) {
        [_nonCommittedComponents addObject: component];
    }
}

- (void) bindComponent: (NVComponent*) component toGroup: (NSString*) group {
    Class type = [component class];
    
	if ([self componentOfType: type isBoundToGroup: group]) {
        [self unbindComponent: type fromGroup: group];

        Debug((@"DB: WARNING - Component %@ is getting bound to group %@, but an instance of the "
               "same component was already present. Existing component was overwritten, but references "
               "may still exist.", component, group));
	}

    @synchronized(_container) {
        NSMutableDictionary* components = [_container valueForKey: group];
        
        if (components == nil) {
            components = [[NSMutableDictionary alloc] init];
            
            [_container setValue: components 
                          forKey: group];
            
            [components release];
        }
        
        NSString* const desc = [[component class] description];
        
        [components setValue: component 
                      forKey: desc];
        
        if (component.database != self) {
            [self retain];
            
            object_setInstanceVariable(component, "_database", self);
        }
        
        if (component.group != group) {
            [group retain];
            
            object_setInstanceVariable(component, "_group", group);
        }
        
        [component start];
        
#ifdef DEBUG
        _debugComponentCount++;
#endif
        
        [self addComponentToCommitQueue: component];
    }
}

- (void) bindComponent: (NVComponent*) component toGroupAndCommit: (NSString*) group {
    [self bindComponent: component toGroup: group];
    
    [self commit];
}

- (void) unbindComponent: (Class) type fromGroup: (NSString*) group {
    if (group == nil) {
        Debug((@"DB: WARNING - An unbind request for component of type %@ was issued, but group was not specified.", type));
        
        return;
    }
    
	NVComponent* const exists = [self getComponentOfType: type fromGroup: group];
	
	if (exists != nil) {
		[self unbindComponent: exists];
	}
}

- (void) unbindAllComponentsFromGroup: (NSString*) group {
    if (group == nil) {
        Debug((@"DB: WARNING - An unbind request for all components in a group was issued, but group was not specified."));
        
        return;
    }
    
    NSArray* const components = [self allComponentsForGroup: group];
    
    for (NVComponent* component in components) {
        [self unbindComponent: component];
    }
}

- (void) unbindComponent: (NVComponent*) component {			
    if (component == nil) {
        Debug((@"DB: WARNING - An unbind request was issued for an unspecified component."));
        
        return;
    }

    Class type = [component class];
    
    if (![self componentOfType: type isBoundToGroup: component.group]) {
        return;
    }
    
    if (component.isLocked) {
        Debug((@"DB: INFO - An unbind request was issued for a locked component ('%@' in group '%@').", type, component.group));
        
        return;
    }
    
    @synchronized(_container) {        
        [component retain];
        
        [[_container valueForKey: component.group] removeObjectForKey: [type description]];
        
        if ([[self allComponentsForGroup: component.group] count] == 0) {
            [_container removeObjectForKey: component.group];
        }

        if (component.database != nil) {
            [component.database release];
            
            object_setInstanceVariable(component, "_database", nil);
        }
        
        if (component.group != nil) {
            [component.group release];
            
            object_setInstanceVariable(component, "_group", nil);
        }
        
        [component end];
        
#ifdef DEBUG
        _debugComponentCount--;
#endif
        
        [self addComponentToCommitQueue: component];
        
        [component release];
    }
}

- (void) unbindComponentAndCommit: (NVComponent*) component {
    [self unbindComponent: component];
    
    [self commit];
}

- (id) getComponentOfType: (Class) type fromGroup: (NSString*) group {    
    if (group == nil) {
        Debug((@"DB: WARNING - A get request for a component of type %@ was issued, but group was "
               "not specified.", type));
        
        return nil;
    }
    
    id result = nil;
    
	@synchronized(_container) { 
        NSDictionary* const components = [_container valueForKey: group];
        
        if (components == nil) {
            Debug((@"DB: WARNING - A get request for a component of type %@ was issued, but no components has "
                   "been bound to the group '%@'", type, group));
        } else {
            result = [components valueForKey: [type description]];
            
            if (result == nil) {
                Debug((@"DB: WARNING - A get request for a component of type %@ was issued, but such a component "
                       "has not been bound to the group '%@'.", type, group));
            }
        }
    };
        
    return result;
}

- (id) getComponentOfAnyType: (Class) type fromGroup: (NSString*) group {
    if (group == nil) {
        Debug((@"DB: WARNING - A get request for a component of type (any) %@ was issued, but the group "
               "was not specified.", type));
        
        return nil;
    }
    
    @synchronized(_container) {
        NSDictionary* const components = [_container valueForKey: group];
        
        if (components == nil) {
            Debug((@"DB: WARNING - A get request for a component of type (any) %@ was issued, but no components has "
                   "been bound to the group '%@'", type, group));
        } else {        
            NSArray* const componentsInGroup = [components allValues];
            
            for (int i = 0; i < [componentsInGroup count]; i++) {
                NSObject* const component = [componentsInGroup objectAtIndex: i];
                
                if ([component isKindOfClass: type]) {
                    return component;
                }
            }
        }
    }

    Debug((@"DB: WARNING - A get request for a component of type (any) %@ was issued, but such a component "
           "has not been bound to the group '%@'.", type, group));
    
	return nil;
}

- (void) commitAdditions {
    
}

- (void) commitDeletions {
    
}

- (void) commit {
    Debug((@"DB: INFO - Committing %u changes (dispatching component events to appropriate services)", _nonCommittedComponents.count));
    
    @synchronized(_nonCommittedComponents) {
        for (int i = _nonCommittedComponents.count - 1; i >= 0; i--) {
            NVComponent* const component = [_nonCommittedComponents objectAtIndex: i];
            
            SEL eventSelector = nil;
            
            if (component.database != nil) {     
                eventSelector = @selector(database:didBind:);
                
                Debug((@"  Dispatched bound event for component %@ to service(s):", component));
            } else {     
                eventSelector = @selector(database:didUnbind:);
                
                Debug((@"  Dispatched unbound event for component %@ to service(s):", component));
            }
            
            for (int j = 0; j < [_services count]; j++) {
                id<NVComponentDatabaseService> const service = [_services objectAtIndex: j];
                
                if ([service respondsToSelector: eventSelector]) {                        
                    if ([service isInterestedInComponent: component]) {
                        [service performSelector: eventSelector 
                                      withObject: self 
                                      withObject: component];
                        
                        Debug((@"    %@", [service class]));
                    }
                }
            }
            
            [_nonCommittedComponents removeLastObject];
        }
    }
}

- (NSArray*) allComponents {
	NSMutableArray* const components = [[[NSMutableArray alloc] init] autorelease];
	
    @synchronized(_container) {
        NSArray* const groups = [_container allKeys];
        
        for (NSUInteger i = 0; i < [groups count]; i++) {
            NSString* const group = [groups objectAtIndex: i];
            NSArray* const componentsInGroup = [[_container valueForKey: group] allValues];
            
            [components addObjectsFromArray: componentsInGroup];
        }
    }
	
	return components;
}

- (NSArray*) allComponentsForGroup: (NSString*) group {
    NSArray* components = nil;
    
    @synchronized(_container) {
        components = [[_container valueForKey: group] allValues];
    }
    
	return components;
}

- (NSArray*) allComponentsForGroup: (NSString*) group ofAnyType: (Class) type {
    NSMutableArray* const components = [[[NSMutableArray alloc] init] autorelease];
    NSArray* const groupComponents = [self allComponentsForGroup: group];
    
    for (int i = 0; i < [groupComponents count]; i++) {
		NSObject* const component = [groupComponents objectAtIndex: i];
		
		if ([component isKindOfClass: type]) {
			[components addObject: component];
		}
	}
    
    return components;
}

- (NSArray*) allComponentsOfType: (Class) type {
	NSMutableArray* const components = [[[NSMutableArray alloc] init] autorelease];
	
    @synchronized(_container) {
        NSArray* const groups = [_container allKeys];
        
        for (int i = 0; i < [groups count]; i++) {
            NSString* const group = [groups objectAtIndex: i];
            NSArray* const componentsInGroup = [[_container valueForKey: group] allValues];
            
            for (int j = 0; j < [componentsInGroup count]; j++) {
                NVComponent* const component = [componentsInGroup objectAtIndex: j];
                
                if ([component class] == type) {
                    [components addObject: component];
                }
            }
        }
    }
	
	return components;
}

- (BOOL) componentOfType: (Class) type isBoundToGroup: (NSString*) group {
    return [[_container valueForKey: group] valueForKey: [type description]] != nil;
}

- (BOOL) componentOfAnyType: (Class) type isBoundToGroup: (NSString*) group {
    NSArray* const componentsInGroup = [[_container valueForKey: group] allValues];
    
    for (int i = 0; i < [componentsInGroup count]; i++) {
        NSObject* const component = [componentsInGroup objectAtIndex: i];
        
        if ([component isKindOfClass: type]) {
            return YES;
        }
    }
    
    return NO;
}

- (void) subscribeService: (id<NVComponentDatabaseService>) service {
    @synchronized(_services) {
        if (![_services containsObject: service]) {
            [_services addObject: service];
        }
    }
}

- (void) unsubscribeService: (id<NVComponentDatabaseService>) service {
    @synchronized(_services) {
        if ([_services containsObject: service]) {
            [_services removeObject: service];
        }
    }
}

#ifdef DEBUG
- (NSUInteger) debugGetComponentCount {
    return _debugComponentCount;
}

- (NSUInteger) debugGetGroupCount {
    return [[_container allKeys] count];
}

- (void) debugPrintContents {
    NSLog(@"\n");
    NSLog(@" -- Printing database contents --");
    
    [self debugPrintServicesPretty];
    [self debugPrintComponentsPretty];
}

- (void) debugPrintServicesPretty {
    NSLog(@"\n");
    NSLog(@" -- Printing services --");
    NSLog(@" ------------------------------------------------------\n\n");    
    
    for (int i = 0; i < [_services count]; i++) {
        id<NVComponentDatabaseService> service = [_services objectAtIndex: i];
        
        NSLog(@"%@", [service class]);
    }
    
    NSLog(@"\n");
    NSLog(@" ------------------------------------------------------\n\n");
}

- (void) debugPrintComponentsPretty {
    NSLog(@"\n");
    NSLog(@" -- Printing components --");
    NSLog(@" - ");
    NSLog(@" - Legend:");
    NSLog(@" ---------");
    NSLog(@"   [group] {");
    NSLog(@"     component (tag)");
    NSLog(@"       <dependencies..[group]>");
    NSLog(@"   }");
    NSLog(@"\n");
    NSLog(@" - note that groups are sorted, but components are not.");
    NSLog(@" ------------------------------------------------------\n\n");
    
    NSArray* groups = [_container allKeys];
    NSMutableArray* groupsSorted = [NSMutableArray arrayWithArray: groups];
    
    [groupsSorted sortUsingSelector: @selector(compare:)];
    
	for (int i = 0; i < [groupsSorted count]; i++) {
		NSString* group = [groupsSorted objectAtIndex: i];
        NSArray* components = [self allComponentsForGroup: group];
        
        NSLog(@"[%@] %u component(s): {", group, components.count);
        
        for (int j = 0; j < components.count; j++) {
            NVComponent* component = [components objectAtIndex: j];
    
            NSString* tag = component.tag != nil ? [NSString stringWithFormat: @" (%@)", component.tag] : @"";
            
            NSLog(@"  %@%@", [component class], tag);
            
            NSArray* dependencies = [component debugGetDependencies];
            
            if (dependencies != nil && dependencies.count > 0) {
                for (int k = 0; k < dependencies.count; k++) {
                    NVComponent* dependency = [dependencies objectAtIndex: k];
                    
                    NSMutableString* dependencyString = [[NSMutableString alloc] init];
                    
                    [dependencyString appendString: @"    "];
                    
                    if (k == 0) {
                        [dependencyString appendString: @"<"];
                    } else {
                        [dependencyString appendString: @" "];
                    }
                    
                    [dependencyString appendFormat: @"%@", [dependency class]];
                    
                    if (dependency.group != component.group) {
                        [dependencyString appendFormat: @" [%@]", dependency.group];
                    }
                    
                    if (k + 1 < dependencies.count) {
                        [dependencyString appendString: @",\n"];
                    } else {
                        [dependencyString appendString: @">"];
                    }
                    
                    NSLog(@"%@", dependencyString);
                    
                    [dependencyString release];
                }
            }
        }
        
        NSLog(@"}\n\n");
    }
    
    NSLog(@" ------------------------------------------------------\n\n");
}
#endif

- (void) dealloc {
	[_container release];
	[_services release];
	
    [_nonCommittedComponents release];
    
	[super dealloc];
}

@end
