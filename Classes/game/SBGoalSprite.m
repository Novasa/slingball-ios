//
//  SBGoalSprite.m
//  slingball
//
//  Created by Jacob H. Hansen on 2/24/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBGoalSprite.h"

@implementation SBGoalSprite

- (id) init {
    if (self = [super init]) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        float width = 128;
        float height = 40;
        
        float x = (screenSize.width / 2) - (width / 2);
        float y = (screenSize.height / 2) - (height / 2);
        
        NVRectFill(self.rect, x, y, width, height);
    }
    return self;
}

@end
