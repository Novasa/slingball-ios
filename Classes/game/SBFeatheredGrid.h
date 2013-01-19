//
//  SBFeatheredGrid.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/7/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"

#define kFeatheredGridLines 30

@interface SBFeatheredGrid : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    
    GLfloat _lineSpacing;
    
    NSUInteger _lines;
    /*
    NVVertex _horizontalVertices[kFeatheredGridLines * 3];
    NVVertex _verticalVertices[kFeatheredGridLines * 3];*/
}

@end
