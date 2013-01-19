//
//  NVCurve.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/2/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVCurve.h"

#import "TBXML.h"

/*
 <curve name="lol" parts="5">
 <part input="0.0" output="10" />
 <part input="0.4" output="12" />
 <part input="0.7" output="18" />
 <part input="0.8" output="25" />
 <part input="1.0" output="30" />
 </curve>
*/

@implementation NVCurve

@synthesize name = _name;

- (id) initWithXMLFileNamed: (NSString*) filename {
    NSString* const path = [[NSBundle mainBundle] pathForResource: filename ofType: @"xml"];
    NSString* const xml = [[NSString alloc] initWithData: [NSData dataWithContentsOfFile: path] encoding: NSUTF8StringEncoding];
    
    if (xml != nil && xml.length > 0) {
        return [self initWithXML: xml];
    }
    
    return nil;
}

- (id) initWithXML: (NSString*) xml {
    if (self = [super init]) {
        TBXML* xmlDoc = [[TBXML alloc] initWithXMLString: xml];
        
        TBXMLElement* const curveElement = xmlDoc.rootXMLElement;
        
        _name = [[xmlDoc valueOfAttributeNamed: @"name" forElement: curveElement] copy];
        
        _partsCount = [[xmlDoc valueOfAttributeNamed: @"parts" forElement: curveElement] integerValue];
        _parts = malloc(sizeof(NVCurvePart) * _partsCount);
        
        TBXMLElement* partElement = [xmlDoc childElementNamed: @"part" parentElement: curveElement];
        
        _parts = malloc(sizeof(NVCurvePart) * _partsCount);
        
        NSUInteger i = 0;
        
        while (partElement != nil) {
            NVCurvePart part;
            
            part.input = [[xmlDoc valueOfAttributeNamed: @"input" forElement: partElement] floatValue];
            part.output = [[xmlDoc valueOfAttributeNamed: @"output" forElement: partElement] floatValue];
            
            _parts[i++] = part;
            
            partElement = [xmlDoc nextSiblingNamed: @"part" searchFromElement: partElement];
        }
        
        [xmlDoc release];
        xmlDoc = nil;    
    }
    return self;
}

- (float) valueForScalar: (float) scalar {
    if (_partsCount > 0) {
        if (scalar > 1) {
            return _parts[_partsCount - 1].output;
        } else if (scalar < 0) {
            return _parts[0].output;
        }
        
        for (NSUInteger i = 0; i < _partsCount - 1; i++) {
            NVCurvePart const a = _parts[i];
            NVCurvePart const b = _parts[i + 1];
            
            if (scalar >= a.input && scalar <= b.input) {
                float const t = scalar / b.input;
                
                return lerp(a.output, b.output, t);
            }
        }
    }
    
    return 0.0f;
}

- (void) dealloc {
    free(_parts);
    
    [_name release];
    
    [super dealloc];
}

@end
