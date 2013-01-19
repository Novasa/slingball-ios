//
//  main.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/21/10.
//  Copyright Novasa Interactive 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    int retVal = -1;
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init]; {
        retVal = UIApplicationMain(argc, argv, nil, nil);
    }
    
    [pool release];
    
    return retVal;
}
