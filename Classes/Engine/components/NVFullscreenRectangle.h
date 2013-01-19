//
//  NVFullscreenRectangle.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"

@interface NVFullscreenRectangle : NVRenderable {
 @private
    NVColor4f* _color;
}

@property(nonatomic, readonly) NVColor4f* color;

@end
