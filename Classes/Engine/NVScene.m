//
//  NVScene.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/21/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVScene.h"

#import "NVComponent.h"
#import "NVLoadableAsyncDelegate.h"

#import "TBXML.h"

@implementation NVScene

@synthesize name = _name;

- (id) initWithFileNamed: (NSString*) file andDatabase: (NVComponentDatabase*) database {
    if (self = [self init]) {
        _database = [database retain];
        _filename = [file copy];
    }
    return self;
}

- (id) init {
    if (self = [super init]) {
        _components = [[NSMutableArray alloc] init];
        _groups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL) handleComponentsFromParentElement: (TBXMLElement*) parentElement inDocument: (TBXML*) xml toGroup: (NSString*) group {
    TBXMLElement* component = [xml childElementNamed: @"component" parentElement: parentElement];
    
    NSUInteger componentCount = 0;
    
    while (component != nil) {
        NSString* componentType = [xml valueOfAttributeNamed: @"type" forElement: component];
        NSString* componentShouldPersist = [xml valueOfAttributeNamed: @"persistent" forElement: component];
        
        Class type = NSClassFromString(componentType);
        
        if (type != nil && [NVComponent classIsComponent: type]) {
            NVComponent* instance = [[type alloc] init];
            
            [_database bindComponent: instance 
                             toGroup: group];
            
            [_components addObject: instance];
            
            if (componentShouldPersist != nil) {
                if ([componentShouldPersist caseInsensitiveCompare: @"YES"] == NSOrderedSame ||
                    [componentShouldPersist caseInsensitiveCompare: @"true"] == NSOrderedSame ||
                    [componentShouldPersist caseInsensitiveCompare: @"1"] == NSOrderedSame) {
                    [instance setIsLocked: YES];
                }
            }
            
            [instance release];
        } else {
            Debug((@"SCENE: WARNING - A scene loaded from file \"%@\" tried binding a component of type '%@' into group '%@', "
                   "but no component of that type was available for instantiation.", _filename, componentType, group));
        }
        
        component = [xml nextSiblingNamed: @"component" searchFromElement: component];
        
        componentCount++;
    }
    
    return componentCount > 0;
}

- (void) loadTemplateFromFileNamed: (NSString*) file toGroup: (NSString*) group {
    TBXML* xml = [[TBXML alloc] initWithXMLFile: file 
                                  fileExtension: @"xml"];
    
    TBXMLElement* root = xml.rootXMLElement;    
    TBXMLElement* template = [xml childElementNamed: @"template" parentElement: root];
    
    [self handleComponentsFromParentElement: template inDocument: xml toGroup: group];
    
    [xml release];
    xml = nil;
}

- (void) handleTemplatesFromParentElement: (TBXMLElement*) parentElement inDocument: (TBXML*) xml toGroup: (NSString*) group {
    TBXMLElement* template = [xml childElementNamed: @"template" parentElement: parentElement];
    
    while (template != nil) {
        NSString* templateFile = [xml valueOfAttributeNamed: @"file" forElement: template];
        
        [self loadTemplateFromFileNamed: templateFile toGroup: group];
        
        template = [xml nextSiblingNamed: @"template" searchFromElement: template];
    }
}

- (void) loadFromFileNamed: (NSString*) file {
    TBXML* xml = [[TBXML alloc] initWithXMLFile: file 
                                  fileExtension: @"xml"];
    
    TBXMLElement* root = xml.rootXMLElement;
    TBXMLElement* scene = [xml childElementNamed: @"scene" parentElement: root];
    
    _name = [[xml valueOfAttributeNamed: @"name" forElement: scene] copy];
    
    Debug((@"SCENE: Loading '%@'", _name));

    TBXMLElement* group = [xml childElementNamed: @"group" parentElement: scene];
    
    while (group != nil) {
        NSString* groupName = [xml valueOfAttributeNamed: @"name" forElement: group];
        
        [_groups addObject: groupName];
        
        [self handleTemplatesFromParentElement: group inDocument: xml toGroup: groupName];
        [self handleComponentsFromParentElement: group inDocument: xml toGroup: groupName];
        
        group = [xml nextSiblingNamed: @"group" searchFromElement: group];
    }
    
    [xml release];
    xml = nil;
}

- (void) loadWithDelegate: (id<NVLoadableAsyncDelegate>) delegate {
    if (_filename == nil || _filename.length == 0) {
        return;
    }

    [self loadFromFileNamed: _filename];
    
    if (delegate != nil) {
        SEL callback = @selector(loadableDidLoad:);
        
        if ([delegate respondsToSelector: callback]) {
            [delegate performSelector: callback 
                           withObject: self];
        }
    }
}

- (void) unloadWithDelegate: (id<NVLoadableAsyncDelegate>) delegate {
    Debug((@"SCENE: Unloading '%@'", _name));
    
    for (NSString* group in _groups) {
        [_database unbindAllComponentsFromGroup: group];
    }
    
    if (delegate != nil) {
        SEL callback = @selector(loadableDidUnload:);
        
        if ([delegate respondsToSelector: callback]) {
            [delegate performSelector: callback 
                           withObject: self];
        }
    }
}

- (void) dealloc {
    if (_database != nil) {
        [_database release];
        _database = nil;
    }
    
    if (_filename != nil) {
        [_filename release];
        _filename = nil;
    }
    
    if (_name != nil) {
        [_name release];
        _name = nil;
    }
    
    [_groups release];
    [_components release];
    
    [super dealloc];
}

@end
