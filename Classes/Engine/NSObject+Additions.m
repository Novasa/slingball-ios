//
//  NSObject+Additions.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/25/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (Additions)
/*
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
    NSMethodSignature* sig = [self methodSignatureForSelector: selector];
    
    if (sig) {
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature: sig];
        
        [invo setTarget: self];
        [invo setSelector: selector];
        
        [invo setArgument: &p1 atIndex: 2];
        [invo setArgument: &p2 atIndex: 3];
        [invo setArgument: &p3 atIndex: 4];
        
        [invo invoke];
        
        if (sig.methodReturnLength) {
            id anObject;
            
            [invo getReturnValue: &anObject];
            
            return anObject;
        }
    }
    
    return nil;
}
*/
@end
