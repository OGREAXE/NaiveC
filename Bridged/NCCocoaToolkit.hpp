//
//  NCCocoaToolkit.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/20.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCCocoaToolkit_hpp
#define NCCocoaToolkit_hpp

#include <stdio.h>
#include "NCObject.hpp"

#define NC_CLASSNAME_FRAME "Frame"
#define NC_CLASSNAME_SIZE "Size"
#define NC_CLASSNAME_POINT "Point"

class NCFrame : public NCObject{
private:
    float x;
    float y;
    float width;
    float height;
public:
    NCFrame():x(0),y(0),width(0),height(0){};
    NCFrame(float x, float y, float width, float height):x(x),y(y),width(width),height(height){};
    
    float getX(){return x;}
    float getY(){return y;}
    float getWidth(){return width;}
    float getHeight(){return height;}
    
    void setX(float x){this->x = x;}
    void setY(float y){this->y = y;}
    void setWidth(float width){this->width = width;}
    void setHeight(float height){this->height = height;}
};

class NCSize : public NCObject{
private:
    float width;
    float height;
public:
    NCSize():width(0),height(0){};
    NCSize(float width, float height):width(width),height(height){};
    
    float getWidth(){return width;}
    float getHeight(){return height;}
    
    void setWidth(float width){this->width = width;}
    void setHeight(float height){this->height = height;}
};

class NCPoint : public NCObject{
private:
    float x;
    float y;
public:
    NCPoint():x(0),y(0){};
    NCPoint(float x, float y):x(x),y(y){};
    
    float getX(){return x;}
    float getY(){return y;}
    
    void setX(float x){this->x = x;}
    void setY(float y){this->y = y;}
};

#endif /* NCCocoaToolkit_hpp */
