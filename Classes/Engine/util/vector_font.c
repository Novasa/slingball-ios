/*
 *  vector_font.c
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 11/24/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

#include <stdbool.h>

#include "vector_font.h"

static int ascii_to_index(int asciiCode) {
    if (asciiCode >= 48 && asciiCode <= 57) {
        return asciiCode - 48;
    } else if (asciiCode >= 65 && asciiCode <= 90) {
        return 10 + (asciiCode - 65);
    }

    switch (asciiCode) {
        case 32: {
            return 36;
        } break;
        
        case 43: { // +
            return 37;
        } break;
            
        case 44:   // ,
        case 46: { // .
            return 38;
        } break;
            
        default: break;
    }
   
    return -1;
}

GLfloat get_width_of_text(const char* text) {    
    int length = strlen(text);
    
    if (length == 1) {
        int index = ascii_to_index(text[0]);
        
        CharData char_data = Char[index];
        
        return char_data.width;
    }
    
    GLfloat accumulatedWidth = 0.0f;
    
    for (int i = 0; i < length; i++) {
        int index = ascii_to_index(text[i]);
        
        CharData char_data = Char[index];
        
        if (i != length - 1) {
            accumulatedWidth += kCharSpacing;
        }
        
        accumulatedWidth += i == 0 ? char_data.width / 2 : char_data.width;
    }
    
    return accumulatedWidth;
}

GLfloat get_height_of_text(const char* text) {
    return 2.0f;
}

void render_text(const char* text) {
    bool shouldDisableVertexArray = false;
    
    if (!glIsEnabled(GL_VERTEX_ARRAY)) {
        glEnableClientState(GL_VERTEX_ARRAY);
        
        shouldDisableVertexArray = true;
    }
    /*
    bool shouldDisableColorMaterial = false;
    
    if (!glIsEnabled(GL_COLOR_MATERIAL)) {
        glEnable(GL_COLOR_MATERIAL);
        
        shouldDisableColorMaterial = true;
    }
    */
    int length = strlen(text);
    
    for (int i = 0; i < length; i++) {
        int index = ascii_to_index(text[i]);
        
        CharData char_data = Char[index];
        
        if (i > 0) {
            glTranslatef((char_data.width / 2), 0, 0);
        }
        
        glVertexPointer(2, GL_FLOAT, 0, char_data.vertices);
        glDrawArrays(GL_LINE_STRIP, 0, char_data.vertexCount);      
        
        glTranslatef((char_data.width / 2) + kCharSpacing, 0, 0);
    }
    
    if (shouldDisableVertexArray) {
        glDisableClientState(GL_VERTEX_ARRAY);
    }
    /*
    if (shouldDisableColorMaterial) {
        glDisable(GL_COLOR_MATERIAL);
    }*/
}

void render_text_along_vector(const char* text, kmVec3* alongVector) {
    glEnableClientState(GL_VERTEX_ARRAY);
    
    int length = strlen(text);
    
    for (int i = 0; i < length; i++) {
        int index = ascii_to_index(text[i]);
        
        CharData char_data = Char[index];
        
        kmVec3 translation;
        kmVec3Fill(&translation, alongVector->x, alongVector->y, alongVector->z);
        kmVec3Scale(&translation, &translation, (char_data.width / 2));
    
        if (i > 0) {    
            glTranslatef(translation.x, translation.y, translation.z);
        }
        
        glVertexPointer(2, GL_FLOAT, 0, char_data.vertices);
        glDrawArrays(GL_LINE_STRIP, 0, char_data.vertexCount);      
        
        kmVec3Fill(&translation, alongVector->x, alongVector->y, alongVector->z);
        kmVec3Scale(&translation, &translation, (char_data.width / 2) + kCharSpacing);
        
        glTranslatef(translation.x, translation.y, translation.z);
    }
    
    glDisableClientState(GL_VERTEX_ARRAY);
}
