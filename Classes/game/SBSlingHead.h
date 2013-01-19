//
//  SBSlingHead.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/11/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVRenderable.h"
#import "NVTransformable.h"
#import "SBSlingBody.h"

@interface SBSlingHead : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBSlingBody, _body);
    
    NVColor4f* _color;
    
    NSUInteger _playerIndex;
}

@property(nonatomic, readonly) NVColor4f* color;

@end
