//
//  NVScreenSpacedOrthographicCamera.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 3/7/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NVScreenSpacedOrthographicCamera.h"

@implementation NVScreenSpacedOrthographicCamera

- (id) init {
    if (self = [super init]) {
        self.near = -1;
        self.far = 1;
    }
    return self;
}

- (void) construct {
    [super construct];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    kmMat4OrthographicProjection(_projection, 
                                 0, screenSize.width, 
                                 0, screenSize.height, 
                                 self.near, self.far);
}

@end
