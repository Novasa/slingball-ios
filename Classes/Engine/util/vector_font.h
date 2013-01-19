/*
 *  numbers.h
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 11/23/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

#import "NV.h"

#define kCharSpacing 0.33f

static const GLfloat NumberZero[] = {
    -1, -1,
    -1, 1,
    1, 1,
    1, -1,
    -1, -1,
    1, 1
};

static const GLfloat NumberOne[] = {
    0, -1,
    0, 1,
};

static const GLfloat NumberTwo[] = {
    1, -1,
    -1, -1,
    -1, -0.5f,
    1, 0.25f, 
    1, 1,
    -1, 1
};

static const GLfloat NumberThree[] = {
    -1, -1,
    1, -1,
    1, 0,
    -1, 0,
    1, 0,
    1, 1,
    -1, 1
};

static const GLfloat NumberFour[] = {
    1, -1,
    1, 1,
    1, 0,
    -1, 0,
    -1, 1
};

static const GLfloat NumberFive[] = {
    -1, -0.5f,
    -1, -1,
    1, -1,
    1, 0,
    -1, 0,
    -1, 1,
    1, 1
};

static const GLfloat NumberSix[] = {
    -1, 1,
    -1, -1,
    1, -1,
    1, 0,
    -1, 0
};

static const GLfloat NumberSeven[] = {
    -1, -1,
    1, 1,
    -1, 1
};

static const GLfloat NumberEight[] = {
    1, -1,
    -1, -1,
    -1, 1,
    1, 1,
    1, -1,
    1, 0,
    -1, 0
};

static const GLfloat NumberNine[] = {
    1, -1,
    1, 1,
    -1, 1,
    -1, 0,
    1, 0
};

static const GLfloat CharacterPlus[] = {
    0, -1,
    0, 1,
    0, 0,
    -1, 0,
    1, 0
};

static const GLfloat CharacterPeriod[] = {
    0.1f, -1,
    -0.1f, -1,
    -0.1f, -0.9f,
    0.1f, -0.9f
};

static const GLfloat CharacterWhitespace[] = {
    
};

static const GLfloat CharacterA[] = {
    1, -1,
    0, 1,
    -1, -1,
    -0.5f, 0,
    0.5f, 0
};

static const GLfloat CharacterB[] = { 
    -1, -1,
    0.5f, -1,
    1, -0.75f,
    1, -0.25f,
    0.5f, 0,
    -1, 0,
    0.5f, 0,
    1, 0.25f,
    1, 0.75f,
    0.5f, 1,
    -1, 1,
    -1, -1
};

static const GLfloat CharacterC[] = { 
    1, -1,
    -1, -1,
    -1, 1,
    1, 1
};

static const GLfloat CharacterD[] = { 
    -1, -1,
    0.5f, -1,
    1, -0.5f,
    1, 0.5f,
    0.5f, 1,
    -1, 1,
    -1, -1
};

static const GLfloat CharacterE[] = { 
    1, -1,
    -1, -1,
    -1, 0,
    1, 0,
    -1, 0,
    -1, 1,
    1, 1
};

static const GLfloat CharacterF[] = { 
    -1, -1,
    -1, 0.25f,
    0.5f, 0.25f,
    -1, 0.25f,
    -1, 1,
    1, 1
};

static const GLfloat CharacterG[] = { 
    0, -0.25f,
    0, 0,
    1, 0,
    1, -1,
    -1, -1,
    -1, 1,
    1, 1
};

static const GLfloat CharacterH[] = { 
    1, -1,
    1, 1,
    1, 0,
    -1, 0,
    -1, 1,
    -1, -1
};

static const GLfloat CharacterI[] = { 
    0.5f, -1,
    -0.5f, -1,
    0, -1,
    0, 1,
    0.5f, 1,
    -0.5f, 1
};

static const GLfloat CharacterJ[] = { 
    -1, -0.75f,
    -1, -1,
    1, -1,
    1, 1,
    -0.5f, 1
};

static const GLfloat CharacterK[] = { 
    1, -1,
    -1, 0,
    1, 1,
    -1, 0,
    -1, 1,
    -1, -1
};

static const GLfloat CharacterL[] = { 
    1, -1,
    -1, -1,
    -1, 1
};

static const GLfloat CharacterM[] = { 
    -1, -1,
    -1, 1,
    0, -0.5f,
    1, 1,
    1, -1
};

static const GLfloat CharacterN[] = { 
    1, 1,
    1, -1,
    -1, 1,
    -1, -1
};

static const GLfloat CharacterO[] = { 
    1, -1,
    -1, -1,
    -1, 1,
    1, 1,
    1, -1
};

static const GLfloat CharacterP[] = { 
    -1, -1,
    -1, 1,
    1, 1,
    1, 0,
    -1, 0
};

static const GLfloat CharacterQ[] = {
    1, -1,
    -1, -1,
    -1, 1,
    1, 1,
    -1, -1
};

static const GLfloat CharacterR[] = { 
    1, -1,
    -0.25f, 0,
    1, 0,
    1, 1,
    -1, 1,
    -1, -1
};

static const GLfloat CharacterS[] = { 
    1, 0.75f,
    1, 1,
    -1, 1,
    -1, 0,
    1, 0,
    1, -1,
    -1, -1,
    -1, -0.75f
};

static const GLfloat CharacterT[] = { 
    0, -1,
    0, 1,
    1, 1,
    -1, 1
};

static const GLfloat CharacterU[] = { 
    1, 1,
    1, -1,
    -1, -1,
    -1, 1
};

static const GLfloat CharacterV[] = { 
    1, 1,
    0, -1,
    -1, 1
};

static const GLfloat CharacterW[] = { 
    1, 1,
    0.5f, -1,
    0, 1,
    -0.5f, -1,
    -1, 1
};

static const GLfloat CharacterX[] = { 
    -1, -1,
    1, 1,
    0, 0,
    1, -1,
    -1, 1
};

static const GLfloat CharacterY[] = { 
    0, -1,
    0, 0,
    1, 1,
    0, 0,
    -1, 1
};

static const GLfloat CharacterZ[] = { 
    1, -1,
    -1, -1,
    1, 1,
    -1, 1
};

typedef struct {
    GLfloat width;
    GLint vertexCount;
    const GLfloat* vertices;
} CharData;

static const CharData Char[] = {
    { 2,    6, NumberZero },
    { 1,    2, NumberOne },
    { 2,    6, NumberTwo },
    { 2,    7, NumberThree },
    { 2,    5, NumberFour },
    
    { 2,    7, NumberFive },
    { 2,    5, NumberSix },
    { 2,    3, NumberSeven },
    { 2,    7, NumberEight },
    { 2,    5, NumberNine },
 
    { 2,    5, CharacterA }, 
    { 2,    12, CharacterB }, 
    { 2,    4, CharacterC }, 
    { 2,    7, CharacterD }, 
    { 2,    7, CharacterE },  
    { 2,    6, CharacterF }, 
    { 2,    7, CharacterG }, 
    { 2,    6, CharacterH }, 
    { 2,    6, CharacterI }, 
    { 2,    5, CharacterJ }, 
    { 2,    6, CharacterK }, 
    { 2,    3, CharacterL }, 
    { 2,    5, CharacterM }, 
    { 2,    4, CharacterN }, 
    { 2,    5, CharacterO }, 
    { 2,    5, CharacterP }, 
    { 2,    5, CharacterQ },
    { 2,    6, CharacterR }, 
    { 2,    8, CharacterS }, 
    { 2,    4, CharacterT }, 
    { 2,    4, CharacterU }, 
    { 2,    3, CharacterV }, 
    { 2,    5, CharacterW }, 
    { 2,    5, CharacterX }, 
    { 2,    5, CharacterY }, 
    { 2,    4, CharacterZ }, 
    
    { 2,    0, CharacterWhitespace }, // index 36
    { 2,    5, CharacterPlus }, // index: 37
    { 0.33f, 4, CharacterPeriod }, // index: 38
};

static int ascii_to_index(int asciiCode);
GLfloat get_width_of_text(const char* text);
GLfloat get_height_of_text(const char* text);
void render_text(const char* text);
void render_text_along_vector(const char* text, kmVec3* alongVector);
