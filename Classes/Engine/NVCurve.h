//
//  NVCurve.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/2/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    float input;
    float output;
} NVCurvePart;

@interface NVCurve : NSObject {
 @private
    NSString* _name;
    
    NVCurvePart* _parts;
    NSUInteger _partsCount;
}

@property(nonatomic, readonly) NSString* name;

- (id) initWithXMLFileNamed: (NSString*) filename;
- (id) initWithXML: (NSString*) xml;

- (float) valueForScalar: (float) scalar;

@end
