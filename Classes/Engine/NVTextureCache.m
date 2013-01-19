//
//  NVTextureCache.m
//  slingball
//
//  Created by Jacob Hansen on 2/16/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import "NVTextureCache.h"

#import "SynthesizeSingleton.h"

@implementation NVTextureCache

SYNTHESIZE_SINGLETON_FOR_CLASS(NVTextureCache, Cache);

- (id) init {
	if (self = [super init]) {
		_cache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

// taken from http://www.iphonedevsdk.com/forum/iphone-sdk-game-development/9607-help-using-textures.html
- (GLuint) setTextureFromImageNamed: (NSString*) name {
    NSNumber* textureNumber = nil;
    
    @synchronized(_cache) {
        textureNumber = [_cache objectForKey: name];
        
        if (textureNumber != nil){
            GLuint textureInt = [textureNumber unsignedIntValue];
            
            //texture is already in gl - reference it by int.
            glBindTexture(GL_TEXTURE_2D, textureInt);
            
            return textureInt;
        }
        
        CGImageRef spriteImage;
        CGContextRef spriteContext;
        GLubyte *spriteData;
        size_t	width, height;
        
        // Creates a Core Graphics image from an image file
        spriteImage = [UIImage imageNamed:name].CGImage;
        // Get the width and height of the image
        width = CGImageGetWidth(spriteImage);
        height = CGImageGetHeight(spriteImage);
        
        // Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
        // you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.	
        if (spriteImage) {
            // Allocated memory needed for the bitmap context
            spriteData = (GLubyte *) calloc(width * height, 4);
            // Uses the bitmatp creation function provided by the Core Graphics framework. 
            spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
            // After you create the context, you can draw the sprite image to the context.
            CGContextDrawImage(spriteContext, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), spriteImage);
            // You don't need the context at this point, so you need to release it to avoid memory leaks.
            CGContextRelease(spriteContext);
            
            GLuint spriteTexture;
            
            // Use OpenGL ES to generate a name for the texture.
            glGenTextures(1, &spriteTexture);
            // Bind the texture name. 
            glBindTexture(GL_TEXTURE_2D, spriteTexture);
            // Speidfy a 2D texture image, provideing the a pointer to the image data in memory
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
            // Release the image data
            free(spriteData);
            
            // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
            //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

            textureNumber = [NSNumber numberWithUnsignedInt:spriteTexture];
            
            [_cache setObject:textureNumber forKey: name];
        }
	}
    
	return [textureNumber intValue];
}

- (void) flush {
    @synchronized(_cache) {
        NSArray *textureKeys = [_cache allKeys];
        
        if ([textureKeys count] > 0) {
            uint textureIds[[textureKeys count]];
            
            for (int i = 0; i < [textureKeys count]; i++) {
                id key = [textureKeys objectAtIndex: i];
                NSNumber *textureNumber = [_cache objectForKey: key];
                int textureId = [textureNumber intValue];
                
                textureIds[i] = textureId;
            }
            
            glDeleteTextures([textureKeys count], textureIds);
        }
    }
}

- (void) freeTextureFromName: (NSString*) name {
    @synchronized(_cache) {
        NSNumber *textureNumber = [_cache objectForKey: name];
        
        [_cache removeObjectForKey: name];
        
        NSUInteger textureId = [textureNumber unsignedIntValue];
        
        GLuint textureIds[] = {
            textureId
        };
        
        glDeleteTextures(1, textureIds);
    }
}

- (void) dealloc {
	[_cache release];
	
	[super dealloc];
}

@end
