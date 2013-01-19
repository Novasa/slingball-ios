//
//  SBScanlines.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/9/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"

@interface SBScanlines : NVRenderable {
 @private
    GLfloat _spacing;
    
    GLfloat _lineSize;
    GLfloat _alpha;
    
    NSUInteger _lines;
    
    NVVertex* _vertices;
}

@end
