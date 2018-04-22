//
//  NCHeapMemory.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/4/20.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCHeapMemory_hpp
#define NCHeapMemory_hpp

#include "NCStackElement.hpp"

#include <stdio.h>
#include <string>
#include <unordered_map>
#include <mutex>

class NCHeapMemory {
private:
    NCHeapMemory(){
    }
    
    static NCHeapMemory * m_pSharedMem;
    
    std::unordered_map<std::string, shared_ptr<NCStackElement>> elementMap;
    
    std::mutex m_mutex;
    
public:
    static NCHeapMemory* GetSharedMemory()
    {
        if ( m_pSharedMem == NULL )
            m_pSharedMem = new NCHeapMemory();
        return m_pSharedMem;
    }
    
    void setElement(const std::string&key,  std::shared_ptr<NCStackElement>&);
    
    std::shared_ptr<NCStackElement> getElement(const std::string&key);
};

#endif /* NCHeapMemory_hpp */
