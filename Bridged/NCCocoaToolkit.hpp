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
#define NC_CLASSNAME_RANGE "Range"
#define NC_CLASSNAME_EDGEINSET "EdgeInset"

class NCRect : public NCObject{
public:
    float x;
    float y;
    float width;
    float height;
public:
    NCRect():x(0),y(0),width(0),height(0){};
    NCRect(float x, float y, float width, float height):x(x),y(y),width(width),height(height){};
    
    float getX(){return x;}
    float getY(){return y;}
    float getWidth(){return width;}
    float getHeight(){return height;}
    
    void setX(float x){this->x = x;}
    void setY(float y){this->y = y;}
    void setWidth(float width){this->width = width;}
    void setHeight(float height){this->height = height;}
    
    virtual string getDescription();
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
};

class NCSize : public NCObject{
public:
    float width;
    float height;
public:
    NCSize():width(0),height(0){};
    NCSize(float width, float height):width(width),height(height){};
    
    float getWidth(){return width;}
    float getHeight(){return height;}
    
    void setWidth(float width){this->width = width;}
    void setHeight(float height){this->height = height;}
    
    virtual string getDescription();
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
};

class NCPoint : public NCObject{
public:
    float x;
    float y;
public:
    NCPoint():x(0),y(0){};
    NCPoint(float x, float y):x(x),y(y){};
    
    float getX(){return x;}
    float getY(){return y;}
    
    void setX(float x){this->x = x;}
    void setY(float y){this->y = y;}
    
    virtual string getDescription();
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
};

#define NCRANGE_TYPE long
class NCRange : public NCObject{
public:
    NCRANGE_TYPE location;
    NCRANGE_TYPE length;
public:
    NCRange():location(0),length(0){};
    NCRange(NCRANGE_TYPE location, NCRANGE_TYPE length):location(location),length(length){};
    
    float getLocation(){return location;}
    float getLength(){return length;}
    
    void setLocation(NCRANGE_TYPE l){this->location = l;}
    void setLength(NCRANGE_TYPE l){this->length = l;}
    
    virtual string getDescription();
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
};

class NCEdgeInset : public NCObject{
public:
    float top;
    float left;
    float bottom;
    float right;
public:
    NCEdgeInset():top(0),left(0),bottom(0),right(0){};
    NCEdgeInset(float t, float l, float b, float r):top(t),left(l),bottom(b),right(r){};
    
    float getTop(){return top;}
    float getLeft(){return left;}
    float getBottom(){return bottom;}
    float getRight(){return right;}
    
    void setTop(float t){this->top = t;}
    void setLeft(float l){this->left = l;}
    void setBottom(float b){this->bottom = b;}
    void setRight(float r){this->right = r;}
    
    virtual string getDescription();
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
};

class NCOcClass : public NCObject{
private:
    void * pClass;
public:
    NCOcClass(){};
    NCOcClass(void * pClass):pClass(pClass){};
    
    void * getClass;
    
    virtual string getDescription();
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
};

#endif /* NCCocoaToolkit_hpp */
