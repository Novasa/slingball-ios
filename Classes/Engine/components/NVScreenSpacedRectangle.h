//
//  NVScreenSpacedRectangle.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/23/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"

@interface NVScreenSpacedRectangle : NVRenderable {
 @private
    NVRect* _rect;
    NVColor4f* _color;
}

@property(nonatomic, readonly) NVRect* rect;
@property(nonatomic, readonly) NVColor4f* color;

@end
